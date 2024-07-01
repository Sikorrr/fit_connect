import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/response.dart';
import '../../../../core/api/result_status.dart';
import '../../../../core/config/config.dart';
import '../../../../core/dependency_injection/dependency_injection.dart';
import '../../../../core/error/error_manager.dart';
import '../../domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;
  final ErrorManager _errorManager;

  AuthRepositoryImpl(
    @Named(firebaseAuthInstance) this._firebaseAuth,
    @Named(googleSignInInstance) this._googleSignIn,
    @Named(facebookAuthInstance) this._facebookAuth,
    this._errorManager,
  );

  @override
  Future<Response> login(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return _evaluateUser(userCredential.user);
    } catch (e, s) {
      return _handleException(message: 'login_failed', e: e, s: s);
    }
  }

  @override
  Future<Response> register(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return _evaluateUser(userCredential.user);
    } catch (e, s) {
      return _handleException(message: 'register_failed', e: e, s: s);
    }
  }

  Response _evaluateUser(User? user) {
    if (user == null) return Response(ResultStatus.error);
    return user.emailVerified
        ? Response(ResultStatus.success)
        : Response(AuthResultStatus.emailNotVerified);
  }

  Future<Response> signInWithFirebase(AuthCredential credential) async {
    await _firebaseAuth.signInWithCredential(credential);
    return Response(ResultStatus.success);
  }

  @override
  Future<Response> logOut() async {
    try {
      await _firebaseAuth.signOut();
      return Response(ResultStatus.success);
    } catch (e, s) {
      return _handleException(message: 'sign_out_error', e: e, s: s);
    }
  }

  @override
  Future<Response> loginWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await authenticateOrLinkUser(credential);
        return Response(ResultStatus.success);
      } else {
        return _handleException(message: 'google_signin_cancelled');
      }
    } catch (e, s) {
      return _handleException(message: 'google_signin_error', e: e, s: s);
    }
  }

  @override
  Future<Response> loginWithFacebook() async {
    try {
      LoginResult loginResult = await _facebookAuth.login();
      if (loginResult.status == LoginStatus.success) {
        final OAuthCredential credential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);
        await authenticateOrLinkUser(credential);
        return Response(ResultStatus.success);
      } else {
        return _handleException(
            message: 'facebook_signin_error',
            e: Exception(loginResult.message));
      }
    } catch (e, s) {
      return _handleException(message: 'facebook_signin_error', e: e, s: s);
    }
  }

  Future<Response> authenticateOrLinkUser(OAuthCredential credential) async {
    if (_firebaseAuth.currentUser != null) {
      return await linkAccountWithCredential(
          credential, _firebaseAuth.currentUser!);
    } else {
      return await signInWithFirebase(credential);
    }
  }

  Future<Response> linkAccountWithCredential(
      AuthCredential credential, User user) async {
    await user.linkWithCredential(credential);
    return Response(ResultStatus.success);
  }

  @override
  Future<Response> sendVerificationEmail() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification(ActionCodeSettings(
          url: verificationUrl,
        ));
        return Response(ResultStatus.success);
      } catch (e, s) {
        return _handleException(
            message: 'Failed to send verification email', e: e, s: s);
      }
    }
    return _handleException();
  }

  @override
  Future<Response> applyActionCode(String code) async {
    try {
      await _firebaseAuth.applyActionCode(code);
      await _firebaseAuth.currentUser?.reload();
      return Response(ResultStatus.success);
    } catch (e, s) {
      return _handleException(message: 'apply_action_code_error', e: e, s: s);
    }
  }

  @override
  Future<(String?, Response)> verifyPasswordResetCode(String code) async {
    try {
      String email = await _firebaseAuth.verifyPasswordResetCode(code);
      return (email, Response(ResultStatus.success));
    } catch (e, s) {
      return (
        null,
        _handleException(message: 'failed_to_verify_password', e: e, s: s)
      );
    }
  }

  @override
  Future<Response> confirmPasswordReset(String code, String newPassword) async {
    try {
      _firebaseAuth.confirmPasswordReset(code: code, newPassword: newPassword);
      return Response(ResultStatus.success);
    } catch (e, s) {
      return _handleException(
          message: 'failed_to_confirm_password', e: e, s: s);
    }
  }

  @override
  Future<Response> resetPassword(String email) async {
    try {
      _firebaseAuth.sendPasswordResetEmail(email: email);
      return Response(ResultStatus.success);
    } catch (e, s) {
      return _handleException(
          message: 'failed_to_send_password_reset_email', e: e, s: s);
    }
  }

  Response<T> _handleException<T>({String? message, Object? e, StackTrace? s}) {
    return _errorManager.handleException(message ?? 'unknown_error',
        exception: e, stackTrace: s);
  }
}

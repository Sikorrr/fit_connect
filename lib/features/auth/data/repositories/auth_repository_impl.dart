import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/response.dart';
import '../../../../core/api/result_status.dart';
import '../../../../core/error_manager.dart';
import '../../domain/repositories/auth_repository.dart';

@lazySingleton
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;
  final ErrorManager _errorManager;

  AuthRepositoryImpl(
    @Named('FirebaseAuthInstance') this._firebaseAuth,
    @Named('GoogleSignInInstance') this._googleSignIn,
    @Named('FacebookAuthInstance') this._facebookAuth,
    this._errorManager,
  );

  @override
  Future<Response> login(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return _evaluateUser(userCredential.user);
    } catch (e, s) {
      return _handleException('login_failed', e: e, s: s);
    }
  }

  @override
  Future<Response> register(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return _evaluateUser(userCredential.user);
    } catch (e, s) {
      return _handleException('register_failed', e: e, s: s);
    }
  }

  Response _evaluateUser(User? user) {
    if (user == null) return Response(ResultStatus.error);
    return Response(ResultStatus.success);
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
      return _handleException('sign_out_error', e: e, s: s);
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
        return _handleException('google_signin_cancelled');
      }
    } catch (e, s) {
      return _handleException('google_signin_error', e: e, s: s);
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
        return _handleException('facebook_signin_error',
            e: Exception(loginResult.message));
      }
    } catch (e, s) {
      return _handleException('facebook_signin_error', e: e, s: s);
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

  Response<T> _handleException<T>(String? message, {Object? e, StackTrace? s}) {
    return _errorManager.handleException(message ?? 'unknown_error',
        exception: e, stackTrace: s);
  }
}

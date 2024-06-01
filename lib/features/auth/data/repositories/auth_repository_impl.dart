import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/config/config.dart';
import '../../domain/repositories/auth_repository.dart';

@lazySingleton
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn =
      GoogleSignIn(clientId: googleSignInClientId);
  final FacebookAuth _facebookAuth = FacebookAuth.instance;

  @override
  Future<bool> login(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      print(
          'Error in login - FirebaseAuthException: ${e.message}, Code: ${e.code}');
      return false;
    } catch (e) {
      print('Error in login - Exception: $e');
      return false;
    }
  }

  @override
  Future<bool> loginWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        return await authenticateOrLinkUser(credential);
      } else {
        print("Google sign-in was aborted.");
        return false;
      }
    } catch (e) {
      print("Error during Google sign-in: $e");
      return false;
    }
  }

  @override
  Future<bool> register(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      print(
          'Error in register - FirebaseAuthException: ${e.message}, Code: ${e.code}');
      return false;
    } catch (e) {
      print('Error in register - Exception: $e');
      return false;
    }
  }

  @override
  Future<bool> signInWithFirebase(AuthCredential credential) async {
    try {
      await _firebaseAuth.signInWithCredential(credential);
      return true;
    } on FirebaseAuthException catch (e) {
      print(
          'Error in signInWithFirebase - FirebaseAuthException: ${e.message}, Code: ${e.code}');
      return false;
    } catch (e) {
      print('Error in signInWithFirebase - Exception: $e');
      return false;
    }
  }

  @override
  Future<bool> logOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } on FirebaseAuthException catch (e) {
      print(
          'Error in logOut - FirebaseAuthException: ${e.message}, Code: ${e.code}');
      return false;
    } catch (e) {
      print('Error in logOut - Exception: $e');
      return false;
    }
  }

  @override
  Future<bool> loginWithFacebook() async {
    try {
      LoginResult loginResult = await _facebookAuth.login();
      if (loginResult.status == LoginStatus.success) {
        final OAuthCredential credential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);
        return await authenticateOrLinkUser(credential);
      } else {
        print("Facebook login failed: ${loginResult.status}");
        return false;
      }
    } catch (e) {
      print("Error during Facebook sign-in: $e");
      return false;
    }
  }

  Future<bool> authenticateOrLinkUser(OAuthCredential credential) async {
    if (_firebaseAuth.currentUser != null) {
      return await linkAccountWithCredential(credential);
    } else {
      return await signInWithFirebase(credential);
    }
  }

  @override
  Future<bool> linkAccountWithCredential(AuthCredential credential) async {
    User? currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      print("No current user to link credential.");
      return false;
    }
    try {
      await currentUser.linkWithCredential(credential);
      return true;
    } catch (e) {
      print("Error in linkAccountWithCredential: $e");
      return false;
    }
  }
}

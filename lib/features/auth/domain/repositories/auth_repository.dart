import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<bool> login(String email, String password);

  Future<bool> loginWithGoogle();

  Future<bool> loginWithFacebook();

  Future<bool> register(String email, String password);

  Future<bool> logOut();

  Future<bool> signInWithFirebase(AuthCredential credential);

  Future<bool> linkAccountWithCredential(AuthCredential credential);
}

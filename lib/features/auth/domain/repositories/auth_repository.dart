import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/api/response.dart';


abstract class AuthRepository {
  Future<Response> login(String email, String password);

  Future<Response> register(String email, String password);

  Future<Response> loginWithGoogle();

  Future<Response> loginWithFacebook();

  Future<Response> logOut();

}

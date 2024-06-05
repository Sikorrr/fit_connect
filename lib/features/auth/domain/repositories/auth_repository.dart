import '../../../../core/api/response.dart';

abstract class AuthRepository {
  Future<Response> login(String email, String password);

  Future<Response> register(String email, String password);

  Future<Response> loginWithGoogle();

  Future<Response> loginWithFacebook();

  Future<Response> logOut();

  Future<bool> applyActionCode(String code);

  Future<Response> sendVerificationEmail();

  Future<(String?, Response)> verifyPasswordResetCode(String code);

  Future<Response> resetPassword(String email);

  Future<Response> confirmPasswordReset(String code, String newPassword);
}

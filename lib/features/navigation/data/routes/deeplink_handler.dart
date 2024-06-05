import 'package:injectable/injectable.dart';

import '../../../../../features/navigation/data/routes/router.dart';
import '../../../../core/api/response.dart';
import '../../../auth/domain/repositories/auth_repository.dart';

@singleton
class DeepLinkHandler {
  final AuthRepository authRepository;

  DeepLinkHandler(this.authRepository);

  static const String _authActionPath = '/__/auth/action';
  static const String _oobCodeKey = 'oobCode';
  static const String _modeKey = 'mode';

  Future<String?> processDeepLink(Uri uri) async {
    if (uri.path.contains(_authActionPath)) {
      String? mode = uri.queryParameters[_modeKey];
      String? code = uri.queryParameters[_oobCodeKey];
      if (code != null) {
        switch (mode) {
          case 'verifyEmail':
            return _handleVerifyEmail(code);
          case 'resetPassword':
            return _handleResetPassword(code);
          default:
            return null;
        }
      }
    }
    return null;
  }

  Future<String?> _handleVerifyEmail(String code) async {
    await authRepository.applyActionCode(code);
    return Routes.home.path;
  }

  Future<String?> _handleResetPassword(String code) async {
    (String?, Response) response =
        await authRepository.verifyPasswordResetCode(code);
    String? email = response.$1;
    String? error = response.$2.message;
    if (email != null) {
      return "${Routes.resetPassword.path}/$code&$email";
    } else {
      return "${Routes.error.path}/$error";
    }
  }
}

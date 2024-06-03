import 'package:injectable/injectable.dart';

import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/navigation/data/routes/router.dart';

@singleton
class DeepLinkHandler {
  final AuthRepository authRepository;

  DeepLinkHandler(this.authRepository);

  static const String _authActionPath = '/__/auth/action';
  static const String _oobCodeKey = 'oobCode';

  Future<String?> processDeepLink(Uri uri) async {
    if (uri.path.contains(_authActionPath)) {
      String? code = uri.queryParameters[_oobCodeKey];
      if (code != null) {
        try {
          await authRepository.applyActionCode(code);
          return Routes.home.path;
        } catch (e) {
          return null;
        }
      }
    }
    return null;
  }
}

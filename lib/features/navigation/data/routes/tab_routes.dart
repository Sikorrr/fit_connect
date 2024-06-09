import 'router.dart';

class TabRoutes {
  static Map<int, String> paths = {
    0: Routes.home.path,
    1: Routes.explore.path,
    2: Routes.messages.path,
    3: Routes.account.path,
  };

  static String getPath(int index) {
    return paths[index] ?? Routes.home.path;
  }

  static List<String> getAllPaths() {
    return paths.values.toList();
  }
}

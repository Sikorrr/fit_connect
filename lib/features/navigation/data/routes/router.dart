import 'package:fit_connect/features/navigation/data/routes/tab_routes.dart';
import 'package:fit_connect/features/user/presentation/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/app_state.dart';
import '../../../../core/dependency_injection.dart';
import '../../../auth/presentation/login_screen.dart';
import '../../../common/presentation/not_found_screen.dart';
import '../../../common/presentation/placeholder_screen.dart';
import '../../presentation/bloc/navigation_bloc.dart';
import '../../presentation/screens/tab_navigator.dart';

enum Routes {
  home("/"),
  login("/login"),
  search("/search"),
  messages("/messages"),
  account("/account");

  const Routes(this.path);

  final String path;
}

class AppRoute {
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    initialLocation: Routes.home.path,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = getIt<AuthState>().isLoggedIn;
      final path = state.uri.path;

      if (isLoggedIn && path == Routes.login.path) {
        /// Redirect to home if already logged in and accessing login page
        return Routes.home.path;
      } else if (!isLoggedIn && _isProtectedRoute(path)) {
        /// Redirect to login if not logged in and trying to access a protected route
        return Routes.login.path;
      }

      /// No redirect if the route is not defined; let it fall through to errorBuilder
      return null;
    },
    refreshListenable: getIt<AuthState>(),
    routes: [
      GoRoute(
        path: Routes.login.path,
        name: Routes.login.name,
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return BlocProvider(
            create: (context) => NavigationBloc(),
            child: TabNavigator(
              child: child,
            ),
          );
        },
        routes: [
          GoRoute(
            path: Routes.home.path,
            pageBuilder: (context, state) => NoTransitionPage(
                child: PlaceholderScreen(title: Routes.home.name)),
          ),
          GoRoute(
            path: Routes.search.path,
            pageBuilder: (context, state) => NoTransitionPage(
                child: PlaceholderScreen(title: Routes.search.name)),
          ),
          GoRoute(
            path: Routes.messages.path,
            pageBuilder: (context, state) => NoTransitionPage(
              child: PlaceholderScreen(title: Routes.messages.name),
            ),
          ),
          GoRoute(
            path: Routes.account.path,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: UserScreen(),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );

  static bool _isProtectedRoute(String path) {
    List<String> protectedRoutes = TabRoutes.getAllPaths();
    return protectedRoutes.contains(path);
  }
}

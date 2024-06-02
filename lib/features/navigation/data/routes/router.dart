import 'package:fit_connect/features/navigation/data/routes/tab_routes.dart';
import 'package:fit_connect/features/user/presentation/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/app_state.dart';
import '../../../../core/dependency_injection.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/screens/auth_screen.dart';
import '../../../common/presentation/not_found_screen.dart';
import '../../../common/presentation/placeholder_screen.dart';
import '../../presentation/bloc/navigation_bloc.dart';
import '../../presentation/screens/tab_navigator.dart';

enum Routes {
  home("/"),
  auth("/auth"),
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
      final isLoggedIn = getIt<AppState>().isLoggedIn;
      final path = state.uri.path;

      if (isLoggedIn && path == Routes.auth.path) {
        /// Redirect to home if already logged in and accessing login page
        return Routes.home.path;
      } else if (!isLoggedIn && _isProtectedRoute(path)) {
        /// Redirect to login if not logged in and trying to access a protected route
        return Routes.auth.path;
      }

      /// No redirect if the route is not defined; let it fall through to errorBuilder
      return null;
    },
    refreshListenable: getIt<AppState>(),
    routes: [
      GoRoute(
        path: Routes.auth.path,
        name: Routes.auth.name,
        builder: (context, state) => BlocProvider(
            create: (context) => AuthBloc(getIt<AuthRepositoryImpl>()),
            child: AuthScreen()),
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
            name: Routes.account.name,
            builder: (context, state) => BlocProvider(
                create: (context) => AuthBloc(getIt<AuthRepositoryImpl>()),
                child: const UserScreen()),
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

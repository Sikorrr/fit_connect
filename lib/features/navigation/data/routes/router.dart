import 'package:fit_connect/features/navigation/data/routes/tab_routes.dart';
import 'package:fit_connect/features/user/presentation/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/app_state.dart';
import '../../../../core/deeplink_handler.dart';
import '../../../../core/dependency_injection.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/screens/auth_screen.dart';
import '../../../auth/presentation/screens/forgot_password_screen.dart';
import '../../../auth/presentation/screens/reset_password_screen.dart';
import '../../../common/presentation/error_screen.dart';
import '../../../common/presentation/not_found_screen.dart';
import '../../../common/presentation/placeholder_screen.dart';
import '../../presentation/bloc/navigation_bloc.dart';
import '../../presentation/screens/tab_navigator.dart';

enum Routes {
  home("/"),
  auth("/auth"),
  search("/search"),
  messages("/messages"),
  account("/account"),
  resetPassword("/resetPassword"),
  forgotPassword("/forgotPassword"),
  error("/error");

  const Routes(this.path);

  final String path;
}

class AppRoute {
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    initialLocation: Routes.home.path,
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      final appState = getIt<AppState>();
      final isLoggedIn = appState.isLoggedIn;
      final deepLinkService = getIt<DeepLinkHandler>();
      final path = state.uri.path;

      String? deeplinkPath = await deepLinkService.processDeepLink(state.uri);
      if (deeplinkPath != null) {
        return deeplinkPath;
      }

      if (isLoggedIn && appState.isEmailVerified && path == Routes.auth.path) {
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
            create: (context) => AuthBloc(getIt<AuthRepository>()),
            child: const AuthScreen()),
      ),
      GoRoute(
        path: "${Routes.error.path}/:error",
        name: Routes.error.name,
        builder: (context, state) {
          String? error = state.pathParameters['error'];
          return ErrorScreen(
            message: error,
          );
        },
      ),
      GoRoute(
          path: "${Routes.resetPassword.path}/:code&:email",
          name: Routes.resetPassword.name,
          builder: (context, state) {
            String? code = state.pathParameters['code'];
            String? email = state.pathParameters['email'];
            if (code != null && email != null) {
              return BlocProvider(
                  create: (context) => AuthBloc(getIt<AuthRepository>()),
                  child: ResetPasswordScreen(code: code, email: email));
            } else {
              return const NotFoundScreen();
            }
          }),
      GoRoute(
        path: Routes.forgotPassword.path,
        name: Routes.forgotPassword.name,
        builder: (context, state) => BlocProvider(
            create: (context) => AuthBloc(getIt<AuthRepository>()),
            child: const ForgotPasswordScreen()),
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
                create: (context) => AuthBloc(getIt<AuthRepository>()),
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_connect/features/home/home_screen.dart';
import 'package:fit_connect/features/navigation/data/routes/tab_routes.dart';
import 'package:fit_connect/features/workout_session/presentation/screens/all_workout_sessions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/constants.dart';
import '../../../../core/api/response.dart';
import '../../../../core/api/result_status.dart';
import '../../../../core/dependency_injection/dependency_injection.dart';
import '../../../../core/state/app_state.dart';
import '../../../account/presentation/bloc/user_data_bloc.dart';
import '../../../account/presentation/bloc/user_data_event.dart';
import '../../../account/presentation/screens/account_creation_screen.dart';
import '../../../account/presentation/screens/account_screen.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/screens/auth_screen.dart';
import '../../../auth/presentation/screens/forgot_password_screen.dart';
import '../../../auth/presentation/screens/reset_password_screen.dart';
import '../../../common/presentation/error_screen.dart';
import '../../../common/presentation/not_found_screen.dart';
import '../../../explore/presentation/bloc/explore_bloc.dart';
import '../../../explore/presentation/bloc/explore_event.dart';
import '../../../explore/presentation/screens/explore_screen.dart';
import '../../../explore/presentation/screens/user_profile_screen.dart';
import '../../../messaging/data/models/conversation.dart';
import '../../../messaging/domain/repositories/message_repository.dart';
import '../../../messaging/presentation/bloc/message_bloc.dart';
import '../../../messaging/presentation/bloc/message_event.dart';
import '../../../messaging/presentation/screens/direct_message_screen.dart';
import '../../../messaging/presentation/screens/messaging_screen.dart';
import '../../../shared/data/models/user.dart' as customUser;
import '../../../shared/domain/repositories/user_repository.dart';
import '../../presentation/bloc/navigation_bloc.dart';
import '../../presentation/screens/tab_navigator.dart';
import 'deeplink_handler.dart';

enum Routes {
  home("/"),
  auth("/auth"),
  messages("/messages"),
  account("/account"),
  resetPassword("/resetPassword"),
  forgotPassword("/forgotPassword"),
  onboarding("/onboarding"),
  explore("/explore"),
  workoutSessions("/workoutSessions"),
  userDetails(":id"),
  directMessage("directMessage/:id"),
  accountInfo("accountInfo"),
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
      final userRepository = getIt<UserRepository>();
      final path = state.uri.path;

      String? deeplinkPath = await deepLinkService.processDeepLink(state.uri);
      if (deeplinkPath != null) {
        return deeplinkPath;
      }

      if (isLoggedIn
          // && appState.isEmailVerified
          &&
          path == Routes.auth.path) {
        Response<bool> response =
            await userRepository.hasCompletedOnboarding(appState.user?.id);
        bool hasCompletedOnboarding =
            response.result == ResultStatus.success ? response.data! : false;

        if (!hasCompletedOnboarding) {
          return Routes.onboarding.path;
        }

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
      GoRoute(
        path: Routes.onboarding.path,
        name: Routes.onboarding.name,
        builder: (context, state) => BlocProvider(
            create: (context) => UserDataBloc(
                getIt<FirebaseAuth>(instanceName: firebaseAuthInstance),
                getIt<UserRepository>()),
            child: AccountCreationScreen()),
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
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
              path: Routes.explore.path,
              pageBuilder: (context, state) => NoTransitionPage(
                  child: BlocProvider(
                      create: (context) => ExploreBloc(getIt<UserRepository>())
                        ..add(FetchUsersEvent()),
                      child: const ExploreScreen())),
              routes: [
                GoRoute(
                  path: Routes.userDetails.path,
                  builder: (context, state) {
                    final customUser.User user = state.extra as customUser.User;
                    return UserProfileScreen(user: user);
                  },
                ),
              ]),
          GoRoute(
              path: Routes.messages.path,
              pageBuilder: (context, state) => NoTransitionPage(
                    child: BlocProvider(
                        create: (context) => MessageBloc(
                            getIt<MessageRepository>(), getIt<UserRepository>())
                          ..add(const LoadAllConversationsEvent()),
                        child: const MessagingScreen()),
                  ),
              routes: [
                GoRoute(
                    path: Routes.directMessage.path,
                    builder: (context, state) {
                      final args = state.extra as Map<String, dynamic>;
                      final user =
                          args[NavigationConstants.userKey] as customUser.User;
                      final Conversation? conversation =
                          args[NavigationConstants.conversationKey];
                      return BlocProvider(
                        create: (context) => MessageBloc(
                            getIt<MessageRepository>(),
                            getIt<UserRepository>()),
                        child: DirectMessageScreen(
                            otherUser: user, conversation: conversation),
                      );
                    }),
              ]),
          GoRoute(
              path: Routes.account.path,
              pageBuilder: (context, state) => NoTransitionPage(
                    child: MultiBlocProvider(providers: [
                      BlocProvider<UserDataBloc>(
                        create: (context) => UserDataBloc(
                          getIt<FirebaseAuth>(
                              instanceName: firebaseAuthInstance),
                          getIt<UserRepository>(),
                        )..add(FetchUserData()),
                      ),
                      BlocProvider<AuthBloc>(
                        create: (context) => AuthBloc(getIt<AuthRepository>()),
                      ),
                    ], child: const AccountScreen()),
                  ),
              routes: [
                GoRoute(
                  path: Routes.accountInfo.path,
                  builder: (context, state) {
                    return const AccountInfoScreen();
                  },
                ),
              ]),
          GoRoute(
            path: Routes.workoutSessions.path,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: AllWorkoutSessionsScreen()),
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

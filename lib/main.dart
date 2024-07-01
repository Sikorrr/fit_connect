import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:url_strategy/url_strategy.dart';

import 'core/config/config.dart';
import 'core/config/firebase_options.dart';
import 'core/dependency_injection/dependency_injection.dart';
import 'core/error/error_manager.dart';
import 'features/account/presentation/bloc/user_data_bloc.dart';
import 'features/account/presentation/bloc/user_data_event.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/messaging/domain/repositories/message_repository.dart';
import 'features/messaging/presentation/bloc/message_bloc.dart';
import 'features/messaging/presentation/bloc/message_event.dart';
import 'features/navigation/data/routes/router.dart';
import 'features/navigation/presentation/bloc/navigation_bloc.dart';
import 'features/shared/domain/repositories/user_repository.dart';
import 'features/workout_session/domain/repositories/workout_session_repository.dart';
import 'features/workout_session/presentation/bloc/workout_session_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kIsWeb) {
    await FacebookAuth.i.webAndDesktopInitialize(
      appId: facebookAppId,
      cookie: true,
      xfbml: true,
      version: "v15.0",
    );
  }
  setPathUrlStrategy();
  AppErrorManager.initialize(CrashlyticsErrorManager());
  configureDependencies();
  runAppWithLocalization();
}

void runAppWithLocalization() {
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('pl')],
      useOnlyLangCode: true,
      path: 'assets/translations',
      fallbackLocale: const Locale('pl'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WorkoutSessionBloc(
            getIt<WorkoutSessionRepository>(),
            getIt<UserRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => AuthBloc(
            getIt<AuthRepository>(),
          ),
        ),

        BlocProvider(
          create: (context) => MessageBloc(
            getIt<MessageRepository>(),
            getIt<UserRepository>(),
          )..add(const LoadAllConversationsEvent()),
        ),
        BlocProvider(
          create: (context) => NavigationBloc(),
        ),
      ],
      child: MaterialApp.router(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        routerConfig: AppRoute.router,
      ),
    );
  }
}

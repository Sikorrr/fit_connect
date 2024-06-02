import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:url_strategy/url_strategy.dart';

import 'core/config/config.dart';
import 'core/config/firebase_options.dart';
import 'core/dependency_injection.dart';
import 'core/error_manager.dart';
import 'features/navigation/data/routes/router.dart';

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
    return MaterialApp.router(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routerConfig: AppRoute.router,
    );
  }
}

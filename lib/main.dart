import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'core/dependency_injection.dart';
import 'features/navigation/data/routes/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
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

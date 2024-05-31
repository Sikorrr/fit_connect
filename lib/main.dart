import 'package:flutter/material.dart';

import 'core/dependency_injection.dart';
import 'features/navigation/data/routes/router.dart';

void main() {
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRoute.router,
    );
  }
}

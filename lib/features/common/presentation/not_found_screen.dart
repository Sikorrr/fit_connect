import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../navigation/data/routes/router.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Page Not Found",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              "Oops! The page you are looking for doesn't exist.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            ElevatedButton(
              onPressed: () => context.go(Routes.home.path),
              child: const Text('Go to Home Page'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../core/app_state.dart';
import '../../../core/dependency_injection.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('User Screen'),
        TextButton(
            onPressed: () {
              getIt<AuthState>().setLogin(false);
            },
            child: const Text("Log out"))
      ],
    )));
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/app_state.dart';
import '../../../core/dependency_injection.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: TextButton(
          onPressed: () {
            getIt<AuthState>().setLogin(true);
          },
          child: Text('login'.tr())),
    ));
  }
}

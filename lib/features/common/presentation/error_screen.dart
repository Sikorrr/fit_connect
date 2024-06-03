import 'package:fit_connect/common_widgets/custom_button.dart';
import 'package:fit_connect/common_widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/sizes.dart';
import '../../navigation/data/routes/router.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, required this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Ups",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Gap(Sizes.p12),
            Text(
              message ?? 'Unknown error',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Gap(Sizes.p12),
            CustomButton(
              onPressed: () => context.go(Routes.home.path),
              label: 'Go to Home Page',
            ),
          ],
        ),
      ),
    );
  }
}

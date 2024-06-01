import 'package:easy_localization/easy_localization.dart';
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
              "page_not_found".tr(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              'page_not_found_subtitle'.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            ElevatedButton(
              onPressed: () => context.go(Routes.home.path),
              child: Text('go_home'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

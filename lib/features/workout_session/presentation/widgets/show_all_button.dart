import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/style_guide.dart';
import '../../../navigation/data/routes/router.dart';

class ShowAllButton extends StatelessWidget {
  const ShowAllButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: Sizes.p16, top: Sizes.p16),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {
            context.go(Routes.workoutSessions.path);
          },
          child: Text(
            "show_all_button".tr(),
            style: const TextStyle(
              color: Colors.deepPurple,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

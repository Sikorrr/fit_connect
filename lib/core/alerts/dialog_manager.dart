import 'package:easy_localization/easy_localization.dart';
import 'package:fit_connect/common_widgets/custom_button.dart';
import 'package:fit_connect/common_widgets/linked_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:injectable/injectable.dart';

import '../../../../constants/sizes.dart';

enum DialogType { success, error, info }

@singleton
class DialogManager {
  void showAppDialog(
      BuildContext context, String title, String message, DialogType type,
      {String? secondaryButtonText,
      VoidCallback? onPrimaryPressed,
      VoidCallback? onSecondaryPressed}) {
    IconData icon;
    Color backgroundColor;
    String buttonText;

    switch (type) {
      case DialogType.success:
        icon = Icons.check_circle;
        backgroundColor = Colors.green;
        buttonText = 'continue'.tr().toUpperCase();
        break;
      case DialogType.error:
        icon = Icons.error;
        backgroundColor = Colors.red;
        buttonText = 'try_again'.tr().toUpperCase();
        break;
      case DialogType.info:
        icon = Icons.info;
        backgroundColor = Colors.amber;
        buttonText = 'OK';
        break;
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Sizes.defaultRadius)),
          title: Icon(icon, size: Sizes.p48, color: backgroundColor),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const Gap(Sizes.p12),
              CustomButton(
                  color: backgroundColor,
                  onPressed: onPrimaryPressed ??
                      () => Navigator.of(dialogContext).pop(),
                  label: buttonText),
              const Gap(Sizes.p12),
              if (secondaryButtonText != null && onSecondaryPressed != null)
                LinkedText(
                  text: secondaryButtonText,
                  onPressed: () {
                    onSecondaryPressed();
                    Navigator.of(dialogContext).pop();
                  },
                )
            ],
          ),
        );
      },
    );
  }
}

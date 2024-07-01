import 'package:easy_localization/easy_localization.dart';
import 'package:fit_connect/common_widgets/custom_button.dart';
import 'package:fit_connect/common_widgets/linked_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:injectable/injectable.dart';

import '../../../../constants/style_guide.dart';

abstract class Dialog {
  IconData get icon;
  Color get backgroundColor;
  String get buttonText;

  String getTitle();
}

class SuccessDialog implements Dialog {
  @override
  IconData get icon => Icons.check_circle;

  @override
  Color get backgroundColor => Colors.green;

  @override
  String get buttonText => 'continue'.tr().toUpperCase();

  @override
  String getTitle() => 'success'.tr();
}

class ErrorDialog implements Dialog {
  @override
  IconData get icon => Icons.error;

  @override
  Color get backgroundColor => Colors.red;

  @override
  String get buttonText => 'try_again'.tr().toUpperCase();

  @override
  String getTitle() => 'error'.tr();
}

class InfoDialog implements Dialog {
  @override
  IconData get icon => Icons.info;

  @override
  Color get backgroundColor => Colors.amber;

  @override
  String get buttonText => 'OK';

  @override
  String getTitle() => 'Info';
}

@singleton
class DialogManager {
  void showAppDialog(
      BuildContext context, String title, String message, Dialog dialogType,
      {String? secondaryButtonText,
      VoidCallback? onPrimaryPressed,
      VoidCallback? onSecondaryPressed}) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Sizes.defaultRadius)),
          title: Icon(dialogType.icon,
              size: Sizes.p48, color: dialogType.backgroundColor),
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
                  color: dialogType.backgroundColor,
                  onPressed: onPrimaryPressed ??
                      () => Navigator.of(dialogContext).pop(),
                  label: dialogType.buttonText),
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

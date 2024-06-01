import 'package:easy_localization/easy_localization.dart';

class Validator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'email_empty'.tr();
    }
    bool isValid =
        RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value);
    if (!isValid) {
      return 'email_invalid'.tr();
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'password_empty'.tr();
    }
    if (value.length < 8) {
      return 'password_short'.tr();
    }
    return null;
  }
}

import 'package:easy_localization/easy_localization.dart';

import '../constants/constants.dart';

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

  static String? validateField(String? value) {
    if (value == null || value.isEmpty) {
      return ('field_cannot_be_empty').tr();
    }
    if (RegExp(r'[0-9]').hasMatch(value)) {
      return ('field_cannot_contain_numbers').tr();
    }
    return null;
  }

  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return ('age_cannot_be_empty').tr();
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return ('age_must_be_number').tr();
    }
    int age = int.parse(value);
    if (age < AppConstants.minUserAge || age > AppConstants.maxUserAge) {
      return ('age_must_be_between').tr(args: [
        AppConstants.minUserAge.round().toString(),
        AppConstants.maxUserAge.round().toString()
      ]);
    }
    return null;
  }
}

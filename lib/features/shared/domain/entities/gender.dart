import 'package:easy_localization/easy_localization.dart';

enum Gender { male, female }

extension GenderExtension on Gender {
  String get displayName {
    switch (this) {
      case Gender.male:
        return ('gender_male').tr();
      case Gender.female:
        return ('gender_female').tr();
    }
  }
}

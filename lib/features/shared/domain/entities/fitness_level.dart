import 'package:easy_localization/easy_localization.dart';

enum FitnessLevel { beginner, intermediate, advanced, notImportant }

extension FitnessLevelExtension on FitnessLevel {
  String get displayName {
    switch (this) {
      case FitnessLevel.beginner:
        return ('fitness_level_beginner').tr();
      case FitnessLevel.intermediate:
        return ('fitness_level_intermediate').tr();
      case FitnessLevel.advanced:
        return ('fitness_level_advanced').tr();
      case FitnessLevel.notImportant:
        return ('fitness_level_not_important').tr();
    }
  }
}

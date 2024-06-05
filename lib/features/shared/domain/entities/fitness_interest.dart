import 'package:easy_localization/easy_localization.dart';

enum FitnessInterest {
  yoga,
  running,
  cycling,
  weightTraining,
  pilates,
  boxing,
  swimming,
  dance,
  crossFit
}

extension FitnessInterestExtension on FitnessInterest {
  String get displayName {
    switch (this) {
      case FitnessInterest.yoga:
        return ('fitness_interest_yoga').tr();
      case FitnessInterest.running:
        return ('fitness_interest_running').tr();
      case FitnessInterest.cycling:
        return ('fitness_interest_cycling').tr();
      case FitnessInterest.weightTraining:
        return ('fitness_interest_weight_training').tr();
      case FitnessInterest.pilates:
        return ('fitness_interest_pilates').tr();
      case FitnessInterest.boxing:
        return ('fitness_interest_boxing').tr();
      case FitnessInterest.swimming:
        return ('fitness_interest_swimming').tr();
      case FitnessInterest.dance:
        return ('fitness_interest_dance').tr();
      case FitnessInterest.crossFit:
        return ('fitness_interest_crossfit').tr();
    }
  }
}

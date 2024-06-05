import 'package:easy_localization/easy_localization.dart';

enum WorkoutTime {
  earlyMorning,
  morning,
  midMorning,
  afternoon,
  lateAfternoon,
  evening,
  night
}

extension WorkoutTimeExtension on WorkoutTime {
  String get displayName {
    switch (this) {
      case WorkoutTime.earlyMorning:
        return ('workout_time_early_morning').tr();
      case WorkoutTime.morning:
        return ('workout_time_morning').tr();
      case WorkoutTime.midMorning:
        return ('workout_time_mid_morning').tr();
      case WorkoutTime.afternoon:
        return ('workout_time_afternoon').tr();
      case WorkoutTime.lateAfternoon:
        return ('workout_time_late_afternoon').tr();
      case WorkoutTime.evening:
        return ('workout_time_evening').tr();
      case WorkoutTime.night:
        return ('workout_time_night').tr();
    }
  }
}

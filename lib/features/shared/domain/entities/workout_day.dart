import 'package:easy_localization/easy_localization.dart';

enum WorkoutDay {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

extension WorkoutDayExtension on WorkoutDay {
  String get displayName {
    switch (this) {
      case WorkoutDay.monday:
        return ('workout_day_monday').tr();
      case WorkoutDay.tuesday:
        return ('workout_day_tuesday').tr();
      case WorkoutDay.wednesday:
        return ('workout_day_wednesday').tr();
      case WorkoutDay.thursday:
        return ('workout_day_thursday').tr();
      case WorkoutDay.friday:
        return ('workout_day_friday').tr();
      case WorkoutDay.saturday:
        return ('workout_day_saturday').tr();
      case WorkoutDay.sunday:
        return ('workout_day_sunday').tr();
      default:
        return '';
    }
  }
}

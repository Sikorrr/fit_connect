import 'package:json_annotation/json_annotation.dart';

import 'workout_day.dart';
import 'workout_time.dart';

part 'workout_day_times.g.dart';

@JsonSerializable()
class WorkoutDayTimes {
  final WorkoutDay day;
  final List<WorkoutTime> times;

  WorkoutDayTimes({required this.day, required this.times});

  factory WorkoutDayTimes.fromJson(Map<String, dynamic> json) =>
      _$WorkoutDayTimesFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutDayTimesToJson(this);

  String get displayName {
    final timesDisplay = times.map((time) => time.displayName).join(', ');
    return '${day.displayName}: $timesDisplay';
  }
}

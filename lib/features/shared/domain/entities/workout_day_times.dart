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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! WorkoutDayTimes) return false;

    if (other.day != day) return false;

    final thisTimesSet = times.toSet();
    final otherTimesSet = other.times.toSet();

    return thisTimesSet.intersection(otherTimesSet).isNotEmpty;
  }

  @override
  int get hashCode =>
      day.hashCode ^ times.fold(0, (sum, item) => sum + item.hashCode);
}

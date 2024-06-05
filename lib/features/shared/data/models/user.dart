import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../constants/constants.dart';
import '../../domain/entities/fitness_interest.dart';
import '../../domain/entities/fitness_level.dart';
import '../../domain/entities/gender.dart';
import '../../domain/entities/workout_day_times.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String email;
  final String name;
  final String age;
  final Gender? gender;
  final List<FitnessInterest> fitnessInterests;
  final FitnessLevel? fitnessLevel;
  @JsonKey(fromJson: _workoutDayTimesFromJson, toJson: _workoutDayTimesToJson)
  final List<WorkoutDayTimes> preferredWorkoutDayTimes;
  final List<Gender> preferredGenderOfWorkoutPartner;
  @JsonKey(fromJson: _rangeValuesFromJson, toJson: _rangeValuesToJson)
  final RangeValues ageRangePreference;
  final String location;
  final String bio;
  final bool hasCompletedOnboarding;

  User({
    required this.id,
    required this.email,
    this.name = '',
    this.age = '',
    this.gender,
    this.fitnessInterests = const [],
    this.fitnessLevel,
    this.preferredWorkoutDayTimes = const [],
    this.preferredGenderOfWorkoutPartner = const [],
    this.ageRangePreference = AppConstants.defaultAgeRange,
    this.location = '',
    this.bio = '',
    this.hasCompletedOnboarding = false,
  });

  User copyWith({
    String? name,
    String? age,
    Gender? gender,
    List<FitnessInterest>? fitnessInterests,
    FitnessLevel? fitnessLevel,
    List<WorkoutDayTimes>? preferredWorkoutDayTimes,
    List<Gender>? preferredGenderOfWorkoutPartner,
    RangeValues? ageRangePreference,
    String? location,
    String? bio,
    bool? hasCompletedOnboarding,
  }) {
    return User(
      id: id,
      email: email,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      fitnessInterests: fitnessInterests ?? this.fitnessInterests,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      preferredWorkoutDayTimes:
          preferredWorkoutDayTimes ?? this.preferredWorkoutDayTimes,
      preferredGenderOfWorkoutPartner: preferredGenderOfWorkoutPartner ??
          this.preferredGenderOfWorkoutPartner,
      ageRangePreference: ageRangePreference ?? this.ageRangePreference,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  static List<WorkoutDayTimes> _workoutDayTimesFromJson(List<dynamic> json) {
    return json
        .map((e) => WorkoutDayTimes.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static List<Map<String, dynamic>> _workoutDayTimesToJson(
      List<WorkoutDayTimes> list) {
    return list.map((e) => e.toJson()).toList();
  }

  static RangeValues _rangeValuesFromJson(Map<String, dynamic> json) {
    return RangeValues(
      (json['start'] as num).toDouble(),
      (json['end'] as num).toDouble(),
    );
  }

  static Map<String, dynamic> _rangeValuesToJson(RangeValues rangeValues) {
    return {
      'start': rangeValues.start,
      'end': rangeValues.end,
    };
  }
}

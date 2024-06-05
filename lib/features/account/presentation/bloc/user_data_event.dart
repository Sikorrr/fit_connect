import 'package:flutter/material.dart';

import '../../../shared/domain/entities/fitness_interest.dart';
import '../../../shared/domain/entities/fitness_level.dart';
import '../../../shared/domain/entities/gender.dart';
import '../../../shared/domain/entities/workout_day_times.dart';

abstract class UserDataEvent {}

class UpdateName extends UserDataEvent {
  final String name;

  UpdateName(this.name);
}

class UpdateAge extends UserDataEvent {
  final String age;

  UpdateAge(this.age);
}

class UpdateGender extends UserDataEvent {
  final Gender gender;

  UpdateGender(this.gender);
}

class UpdateFitnessInterests extends UserDataEvent {
  final List<FitnessInterest> fitnessInterests;

  UpdateFitnessInterests(this.fitnessInterests);
}

class UpdateFitnessLevel extends UserDataEvent {
  final FitnessLevel fitnessLevel;

  UpdateFitnessLevel(this.fitnessLevel);
}

class UpdatePreferredWorkoutTimes extends UserDataEvent {
  final List<WorkoutDayTimes> preferredWorkoutDayTimes;

  UpdatePreferredWorkoutTimes(this.preferredWorkoutDayTimes);
}

class UpdatePreferredGender extends UserDataEvent {
  final List<Gender> gender;

  UpdatePreferredGender(this.gender);
}

class UpdateAgeRangePreference extends UserDataEvent {
  final RangeValues ageRangePreference;

  UpdateAgeRangePreference(this.ageRangePreference);
}

class UpdateLocation extends UserDataEvent {
  final String location;

  UpdateLocation(this.location);
}

class UpdateBio extends UserDataEvent {
  final String bio;

  UpdateBio(this.bio);
}

class FinishOnboarding extends UserDataEvent {}

class UpdateLocationSuggestions extends UserDataEvent {
  final String input;

  UpdateLocationSuggestions(this.input);
}

class ChangePage extends UserDataEvent {
  final int page;

  ChangePage(this.page);
}

class ValidateCurrentStep extends UserDataEvent {}

class FetchUserData extends UserDataEvent {}

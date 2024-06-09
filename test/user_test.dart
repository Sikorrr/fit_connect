import 'package:fit_connect/features/shared/data/models/user.dart';
import 'package:fit_connect/features/shared/domain/entities/fitness_interest.dart';
import 'package:fit_connect/features/shared/domain/entities/fitness_level.dart';
import 'package:fit_connect/features/shared/domain/entities/gender.dart';
import 'package:fit_connect/features/shared/domain/entities/workout_day.dart';
import 'package:fit_connect/features/shared/domain/entities/workout_day_times.dart';
import 'package:fit_connect/features/shared/domain/entities/workout_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('User matches function', () {
    late User currentUser;
    late User matchingUser;
    late User nonMatchingUser;

    setUp(() {
      currentUser = User(
        id: '1',
        email: 'currentuser@example.com',
        name: 'Current User',
        age: '30',
        gender: Gender.male,
        fitnessInterests: [FitnessInterest.running, FitnessInterest.cycling],
        fitnessLevel: FitnessLevel.intermediate,
        preferredWorkoutDayTimes: [
          WorkoutDayTimes(
              day: WorkoutDay.tuesday,
              times: [
                WorkoutTime.earlyMorning, WorkoutTime.morning, WorkoutTime.midMorning,
                WorkoutTime.afternoon, WorkoutTime.lateAfternoon, WorkoutTime.evening, WorkoutTime.night
              ]),
          WorkoutDayTimes(
              day: WorkoutDay.friday,
              times: [
                WorkoutTime.earlyMorning, WorkoutTime.morning, WorkoutTime.midMorning,
                WorkoutTime.afternoon, WorkoutTime.lateAfternoon, WorkoutTime.evening, WorkoutTime.night
              ]),
          WorkoutDayTimes(
              day: WorkoutDay.saturday,
              times: [
                WorkoutTime.earlyMorning, WorkoutTime.morning, WorkoutTime.midMorning,
                WorkoutTime.afternoon, WorkoutTime.lateAfternoon, WorkoutTime.evening, WorkoutTime.night
              ]),
        ],
        preferredGenderOfWorkoutPartner: [Gender.female],
        ageRangePreference: const RangeValues(25, 35),
        location: 'SameLocation',
        bio: 'Bio of current user',
        hasCompletedOnboarding: true,
      );

      matchingUser = User(
        id: '2',
        email: 'matchinguser@example.com',
        name: 'Matching User',
        age: '28',
        gender: Gender.female,
        fitnessInterests: [FitnessInterest.running],
        fitnessLevel: FitnessLevel.intermediate,
        preferredWorkoutDayTimes: [
          WorkoutDayTimes(
              day: WorkoutDay.tuesday,
              times: [
                WorkoutTime.afternoon, WorkoutTime.lateAfternoon, WorkoutTime.evening
              ]),
          WorkoutDayTimes(
              day: WorkoutDay.thursday,
              times: [
                WorkoutTime.afternoon, WorkoutTime.lateAfternoon, WorkoutTime.evening
              ]),
        ],
        preferredGenderOfWorkoutPartner: [Gender.male],
        ageRangePreference: const RangeValues(25, 35),
        location: 'SameLocation',
        bio: 'Bio of matching user',
        hasCompletedOnboarding: true,
      );

      nonMatchingUser = User(
        id: '3',
        email: 'nonmatchinguser@example.com',
        name: 'Non-Matching User',
        age: '40',
        gender: Gender.male,
        fitnessInterests: [FitnessInterest.boxing],
        fitnessLevel: FitnessLevel.advanced,
        preferredWorkoutDayTimes: [
          WorkoutDayTimes(
              day: WorkoutDay.wednesday,
              times: [WorkoutTime.evening, WorkoutTime.night]),
        ],
        preferredGenderOfWorkoutPartner: [Gender.female],
        ageRangePreference: const RangeValues(30, 40),
        location: 'DifferentLocation',
        bio: 'Bio of non-matching user',
        hasCompletedOnboarding: true,
      );
    });

    test('should match a user with overlapping workout day times', () {
      expect(currentUser.matches(matchingUser), isTrue);
    });

    test('should not match a user with no overlapping workout day times', () {
      expect(currentUser.matches(nonMatchingUser), isFalse);
    });

    test('should match a user with FitnessLevel.notImportant', () {
      currentUser = currentUser.copyWith(fitnessLevel: FitnessLevel.notImportant);
      expect(currentUser.matches(matchingUser), isTrue);
    });

    test('should match a user with different fitness levels when one is notImportant', () {
      matchingUser = matchingUser.copyWith(fitnessLevel: FitnessLevel.notImportant);
      expect(currentUser.matches(matchingUser), isTrue);
    });
  });
}

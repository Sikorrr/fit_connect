import 'package:flutter/material.dart';

class FirestoreConstants {
  static const String usersCollection = 'users';
  static const String hasCompletedOnboardingField = 'hasCompletedOnboarding';
}

class AppConstants {
  static const double minUserAge = 16;
  static const double maxUserAge = 99;
  static const RangeValues defaultAgeRange =
      RangeValues(minUserAge, maxUserAge);
}

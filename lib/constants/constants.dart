import 'package:flutter/material.dart';

class FirestoreConstants {
  static const String usersCollection = 'users';
  static const String hasCompletedOnboardingField = 'hasCompletedOnboarding';

  static const String conversationsCollection = 'conversations';
  static const String messagesField = 'messages';
  static const String participantIdsField = 'participantIds';
  static const String sessionsCollection = 'sessions';
}

class AppConstants {
  static const double minUserAge = 16;
  static const double maxUserAge = 99;
  static const RangeValues defaultAgeRange =
      RangeValues(minUserAge, maxUserAge);
}

class NavigationConstants {
  static const String userKey = 'user';
  static const String conversationKey = 'conversation';
}

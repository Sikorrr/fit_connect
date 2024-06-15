import 'package:flutter/material.dart';

import '../../../shared/domain/entities/fitness_interest.dart';
import '../../data/models/workout_session.dart';

class NewSessionState {
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final FitnessInterest? selectedActivity;
  final String location;
  final String? errorMessage;
  final WorkoutSession? initialSession;

  NewSessionState({
    required this.selectedDate,
    required this.selectedTime,
    required this.selectedActivity,
    required this.location,
    required this.errorMessage,
    this.initialSession,
  });

  NewSessionState copyWith({
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    FitnessInterest? selectedActivity,
    String? location,
    String? errorMessage,
    WorkoutSession? initialSession,
  }) {
    return NewSessionState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      selectedActivity: selectedActivity ?? this.selectedActivity,
      location: location ?? this.location,
      errorMessage: errorMessage,
      initialSession: initialSession ?? this.initialSession,
    );
  }
}

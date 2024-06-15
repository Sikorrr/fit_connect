import 'package:equatable/equatable.dart';

import '../../data/models/workout_session.dart';

abstract class WorkoutSessionEvent extends Equatable {
  const WorkoutSessionEvent();

  @override
  List<Object> get props => [];
}

class AddWorkoutSessionEvent extends WorkoutSessionEvent {
  final WorkoutSession workoutSession;
  const AddWorkoutSessionEvent({
    required this.workoutSession,
  });

  @override
  List<Object> get props => [workoutSession];
}

class FetchAllWorkoutSessionsEvent extends WorkoutSessionEvent {
  final bool fetchPast;
  final int? limit;
  const FetchAllWorkoutSessionsEvent({this.fetchPast = false, this.limit});

  @override
  List<Object> get props => [fetchPast];
}

class FetchWorkoutSessionEvent extends WorkoutSessionEvent {
  final String sessionId;

  const FetchWorkoutSessionEvent(this.sessionId);

  @override
  List<Object> get props => [sessionId];
}

class EditWorkoutSessionEvent extends WorkoutSessionEvent {
  final WorkoutSession workoutSession;

  EditWorkoutSessionEvent(this.workoutSession);
}

class RemoveWorkoutSessionEvent extends WorkoutSessionEvent {
  final String sessionId;

  RemoveWorkoutSessionEvent(this.sessionId);
}

class CompleteWorkoutSessionEvent extends WorkoutSessionEvent {
  final WorkoutSession workoutSession;

  CompleteWorkoutSessionEvent(this.workoutSession);
}

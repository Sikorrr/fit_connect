import 'package:equatable/equatable.dart';

import '../../data/models/workout_session.dart';

abstract class WorkoutSessionState extends Equatable {
  const WorkoutSessionState();

  @override
  List<Object> get props => [];
}

class WorkoutSessionInitial extends WorkoutSessionState {}

class WorkoutSessionLoading extends WorkoutSessionState {}

class WorkoutSessionEmpty extends WorkoutSessionState {}

class WorkoutSessionLoaded extends WorkoutSessionState {
  final List<WorkoutSession> sessions;

  const WorkoutSessionLoaded(this.sessions);

  @override
  List<Object> get props => [sessions];
}

class WorkoutSessionError extends WorkoutSessionState {
  final String message;

  const WorkoutSessionError(this.message);

  @override
  List<Object> get props => [message];
}

class WorkoutSessionAdded extends WorkoutSessionState {}

class WorkoutSessionUpdated extends WorkoutSessionState {}

class WorkoutSessionRemoved extends WorkoutSessionState {}

class WorkoutSessionCompleted extends WorkoutSessionState {}

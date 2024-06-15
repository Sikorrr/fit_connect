import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/api/result_status.dart';
import '../../../../core/dependency_injection/dependency_injection.dart';
import '../../../../core/state/app_state.dart';
import '../../../shared/data/models/user.dart';
import '../../../shared/domain/repositories/user_repository.dart';
import '../../data/models/workout_session.dart';
import '../../domain/repositories/workout_session_repository.dart';
import 'workout_session_event.dart';
import 'workout_session_state.dart';

class WorkoutSessionBloc
    extends Bloc<WorkoutSessionEvent, WorkoutSessionState> {
  final WorkoutSessionRepository _repository;
  final UserRepository _userRepository;

  WorkoutSessionBloc(this._repository, this._userRepository)
      : super(WorkoutSessionInitial()) {
    on<AddWorkoutSessionEvent>(_addWorkoutSession);

    on<FetchAllWorkoutSessionsEvent>(_fetchAllWorkoutSessions);

    on<FetchWorkoutSessionEvent>(_fetchWorkoutSession);
    on<EditWorkoutSessionEvent>(_editWorkoutSession);
    on<RemoveWorkoutSessionEvent>(_removeWorkoutSession);
    on<CompleteWorkoutSessionEvent>(_completeWorkoutSession);
  }

  FutureOr<void> _addWorkoutSession(event, emit) async {
    final response = await _repository.addWorkoutSession(event.workoutSession);
    if (response.result == ResultStatus.success) {
      emit(WorkoutSessionAdded());
    } else {
      emit(WorkoutSessionError(response.message!));
    }
  }

  FutureOr<void> _fetchWorkoutSession(event, emit) async {
    emit(WorkoutSessionLoading());
    try {
      final sessionStream = _repository.fetchSession(event.sessionId);
      await emit.forEach<WorkoutSession>(
        sessionStream,
        onData: (session) {
          _updateSessionWithUserDetails(session).then((updatedSession) {
            emit(WorkoutSessionLoaded([updatedSession]));
          });
          return WorkoutSessionLoading();
        },
        onError: (error, stackTrace) => WorkoutSessionError(error.toString()),
      );
    } catch (e) {
      emit(WorkoutSessionError(e.toString()));
    }
  }

  FutureOr<void> _fetchAllWorkoutSessions(event, emit) async {
    emit(WorkoutSessionLoading());
    try {
      final sessionsStream = _repository.getAllSessions(
          fetchPast: event.fetchPast, limit: event.limit);
      await emit.forEach<List<WorkoutSession>>(
        sessionsStream,
        onData: (sessions) {
          _updateSessionsWithUserDetails(sessions).then((updatedSessions) {
            emit(WorkoutSessionLoaded(updatedSessions));
          });
          return WorkoutSessionLoading();
        },
        onError: (error, stackTrace) => WorkoutSessionError(error.toString()),
      );
    } catch (e) {
      emit(WorkoutSessionError(e.toString()));
    }
  }

  Future<List<WorkoutSession>> _updateSessionsWithUserDetails(
      List<WorkoutSession> sessions) async {
    final User? currentUser = getIt<AppState>().user;
    final updatedSessions = <WorkoutSession>[];
    for (var session in sessions) {
      final otherUserId =
          session.participantIds.firstWhere((id) => id != currentUser?.id);
      final response = await _userRepository.getUserProfile(otherUserId);
      if (response.result == ResultStatus.success && response.data != null) {
        updatedSessions.add(session.copyWith(otherUser: response.data));
      } else {
        updatedSessions.add(session);
      }
    }
    return updatedSessions;
  }

  Future<WorkoutSession> _updateSessionWithUserDetails(
      WorkoutSession session) async {
    final User? currentUser = getIt<AppState>().user;
    final otherUserId =
        session.participantIds.firstWhere((id) => id != currentUser?.id);
    final response = await _userRepository.getUserProfile(otherUserId);
    if (response.result == ResultStatus.success && response.data != null) {
      return session.copyWith(otherUser: response.data);
    } else {
      return session;
    }
  }

  FutureOr<void> _editWorkoutSession(
      EditWorkoutSessionEvent event, emit) async {
    final response =
        await _repository.updateWorkoutSession(event.workoutSession);
    if (response.result == ResultStatus.success) {
      emit(WorkoutSessionUpdated());
      add(const FetchAllWorkoutSessionsEvent(fetchPast: false));
    } else {
      emit(WorkoutSessionError(response.message!));
    }
  }

  FutureOr<void> _removeWorkoutSession(
      RemoveWorkoutSessionEvent event, emit) async {
    final response = await _repository.deleteWorkoutSession(event.sessionId);
    if (response.result == ResultStatus.success) {
      emit(WorkoutSessionRemoved());
      add(const FetchAllWorkoutSessionsEvent(fetchPast: false));
    } else {
      emit(WorkoutSessionError(response.message!));
    }
  }

  FutureOr<void> _completeWorkoutSession(
      CompleteWorkoutSessionEvent event, emit) async {
    final updatedSession = event.workoutSession.copyWith(isCompleted: true);
    final response = await _repository.updateWorkoutSession(updatedSession);
    if (response.result == ResultStatus.success) {
      emit(WorkoutSessionCompleted());
      add(const FetchAllWorkoutSessionsEvent(fetchPast: false));
    } else {
      emit(WorkoutSessionError(response.message!));
    }
  }
}

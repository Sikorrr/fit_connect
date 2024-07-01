import 'package:injectable/injectable.dart';

import '../../../../core/api/response.dart';
import '../../../../core/api/result_status.dart';
import '../../../../core/error/error_manager.dart';
import '../../domain/repositories/workout_session_repository.dart';
import '../datasources/remote/workout_session_remote_data_source.dart';
import '../models/workout_session.dart';

@LazySingleton(as: WorkoutSessionRepository)
class WorkoutSessionRepositoryImpl implements WorkoutSessionRepository {
  final ErrorManager _errorManager;
  final WorkoutSessionRemoteDataSource _remoteDataSource;

  WorkoutSessionRepositoryImpl(
    this._remoteDataSource,
    this._errorManager,
  );

  @override
  Future<Response<void>> addWorkoutSession(WorkoutSession session) async {
    try {
      await _remoteDataSource.addWorkoutSession(session);
      return Response(ResultStatus.success);
    } catch (e, s) {
      return _handleException('failed_to_add_workout_session', e: e, s: s);
    }
  }

  @override
  Stream<List<WorkoutSession>> getAllSessions(
      {bool fetchPast = false, int? limit}) {
    return _remoteDataSource
        .getAllSessions(fetchPast: fetchPast, limit: limit)
        .handleError((e, s) =>
            _handleStreamException('failed_to_fetch_sessions', e: e, s: s));
  }

  @override
  Stream<WorkoutSession> fetchSession(String sessionId) {
    return _remoteDataSource.fetchSession(sessionId).handleError((e, s) =>
        _handleStreamException('failed_to_fetch_session', e: e, s: s));
  }

  @override
  Future<Response<void>> updateWorkoutSession(WorkoutSession session) async {
    try {
      await _remoteDataSource.updateWorkoutSession(session);
      return Response(ResultStatus.success);
    } catch (e, s) {
      return _handleException('failed_to_update_workout_session', e: e, s: s);
    }
  }

  @override
  Future<Response<void>> deleteWorkoutSession(String sessionId) async {
    try {
      await _remoteDataSource.deleteWorkoutSession(sessionId);
      return Response(ResultStatus.success);
    } catch (e, s) {
      return _handleException('failed_to_delete_workout_session', e: e, s: s);
    }
  }

  Response<T> _handleException<T>(String message, {Object? e, StackTrace? s}) {
    return _errorManager.handleException(message, exception: e, stackTrace: s);
  }

  Stream<T> _handleStreamException<T>(String message,
      {Object? e, StackTrace? s}) {
    _errorManager.handleException(message, exception: e, stackTrace: s);
    return Stream.error(Exception(message));
  }
}

import '../../../../core/api/response.dart';
import '../../data/models/workout_session.dart';

abstract class WorkoutSessionRepository {
  Future<Response<void>> addWorkoutSession(WorkoutSession session);

  Stream<List<WorkoutSession>> getAllSessions(
      {bool fetchPast = false, int? limit});

  Stream<WorkoutSession> fetchSession(String sessionId);

  Future<Response<void>> updateWorkoutSession(WorkoutSession session);

  Future<Response<void>> deleteWorkoutSession(String sessionId);
}

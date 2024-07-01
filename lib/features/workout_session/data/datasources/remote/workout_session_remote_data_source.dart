import '../../models/workout_session.dart';

abstract class WorkoutSessionRemoteDataSource {
  Future<void> addWorkoutSession(WorkoutSession session);

  Stream<List<WorkoutSession>> getAllSessions({bool fetchPast, int? limit});

  Stream<WorkoutSession> fetchSession(String sessionId);

  Future<void> updateWorkoutSession(WorkoutSession session);

  Future<void> deleteWorkoutSession(String sessionId);
}

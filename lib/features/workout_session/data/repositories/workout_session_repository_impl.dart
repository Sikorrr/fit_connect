import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../constants/constants.dart';
import '../../../../core/api/response.dart';
import '../../../../core/api/result_status.dart';
import '../../../../core/dependency_injection/dependency_injection.dart';
import '../../../../core/error/error_manager.dart';
import '../../../../core/state/app_state.dart';
import '../../../shared/data/models/user.dart';
import '../../domain/repositories/workout_session_repository.dart';
import '../models/workout_session.dart';

@LazySingleton(as: WorkoutSessionRepository)
class WorkoutSessionRepositoryImpl implements WorkoutSessionRepository {
  final FirebaseFirestore _firestore;
  final ErrorManager _errorManager;

  WorkoutSessionRepositoryImpl(
    @Named(firebaseFirestoreInstance) this._firestore,
    this._errorManager,
  );

  @override
  Future<Response<void>> addWorkoutSession(WorkoutSession session) async {
    try {
      final sessionDoc =
          _firestore.collection(FirestoreConstants.sessionsCollection).doc();
      final newSession = session.copyWith(id: sessionDoc.id);
      await sessionDoc.set(newSession.toJson());
      return Response(ResultStatus.success);
    } catch (e, s) {
      return _handleException('failed_to_add_workout_session', e: e, s: s);
    }
  }

  @override
  Stream<List<WorkoutSession>> getAllSessions(
      {bool fetchPast = false, int? limit}) {
    User? currentUser = getIt<AppState>().user;

    try {
      Query query = _firestore
          .collection(FirestoreConstants.sessionsCollection)
          .where(FirestoreConstants.participantIdsField,
              arrayContains: currentUser!.id);

      final now = Timestamp.now();

      if (fetchPast) {
        query = query.where('date', isLessThan: now);
      } else {
        query = query.where('date', isGreaterThanOrEqualTo: now);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      return query.snapshots().handleError((e, s) {
        _handleStreamException('failed_to_fetch_sessions', e: e, s: s);
      }).asyncMap((snapshot) async {
        try {
          return Future.wait(snapshot.docs.map((doc) async {
            final data = doc.data() as Map<String, dynamic>;
            WorkoutSession session = WorkoutSession.fromJson(data);
            return session;
          }).toList());
        } catch (e, s) {
          _handleException('failed_to_fetch_sessions', e: e, s: s);
          return [];
        }
      });
    } catch (e, s) {
      return _handleStreamException('failed_to_fetch_sessions', e: e, s: s);
    }
  }

  @override
  Stream<WorkoutSession> fetchSession(String sessionId) {
    try {
      final sessionDoc = _firestore
          .collection(FirestoreConstants.sessionsCollection)
          .doc(sessionId);

      return sessionDoc.snapshots().asyncMap((snapshot) async {
        if (!snapshot.exists) {
          throw Exception('session_not_found');
        }

        try {
          final data = snapshot.data()!;
          WorkoutSession session = WorkoutSession.fromJson(data);
          return session;
        } catch (e, s) {
          _handleException('failed_to_fetch_session', e: e, s: s);
          throw Exception('failed_to_fetch_session');
        }
      }).handleError((e, s) =>
          _handleStreamException('failed_to_fetch_session', e: e, s: s));
    } catch (e, s) {
      return _handleStreamException('failed_to_fetch_session', e: e, s: s);
    }
  }

  @override
  Future<Response<void>> updateWorkoutSession(WorkoutSession session) async {
    try {
      final sessionDoc = _firestore
          .collection(FirestoreConstants.sessionsCollection)
          .doc(session.id);
      await sessionDoc.update(session.toJson());
      return Response(ResultStatus.success);
    } catch (e, s) {
      return _handleException('failed_to_update_workout_session', e: e, s: s);
    }
  }

  @override
  Future<Response<void>> deleteWorkoutSession(String sessionId) async {
    try {
      final sessionDoc = _firestore
          .collection(FirestoreConstants.sessionsCollection)
          .doc(sessionId);
      await sessionDoc.delete();
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_connect/features/workout_session/data/datasources/remote/workout_session_remote_data_source.dart';
import 'package:injectable/injectable.dart';

import '../../../../../constants/constants.dart';
import '../../../../../core/dependency_injection/dependency_injection.dart';
import '../../models/workout_session.dart';

@LazySingleton(as: WorkoutSessionRemoteDataSource)
class WorkoutSessionRemoteDataSourceImpl
    implements WorkoutSessionRemoteDataSource {
  final FirebaseFirestore _firestore;

  WorkoutSessionRemoteDataSourceImpl(
      @Named(firebaseFirestoreInstance) this._firestore);

  @override
  Future<void> addWorkoutSession(WorkoutSession session) async {
    final sessionDoc =
        _firestore.collection(FirestoreConstants.sessionsCollection).doc();
    final newSession = session.copyWith(id: sessionDoc.id);
    final user = FirebaseAuth.instance.currentUser;
    await sessionDoc.set(newSession.toJson());
  }

  @override
  Stream<List<WorkoutSession>> getAllSessions(
      {bool fetchPast = false, int? limit}) {
    final now = Timestamp.now();
    Query query = _firestore.collection(FirestoreConstants.sessionsCollection);

    if (fetchPast) {
      query = query.where('date', isLessThan: now);
    } else {
      query = query.where('date', isGreaterThanOrEqualTo: now);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().asyncMap((snapshot) async {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return WorkoutSession.fromJson(data);
      }).toList();
    });
  }

  @override
  Stream<WorkoutSession> fetchSession(String sessionId) {
    final sessionDoc = _firestore
        .collection(FirestoreConstants.sessionsCollection)
        .doc(sessionId);
    return sessionDoc.snapshots().asyncMap((snapshot) {
      if (!snapshot.exists) {
        throw Exception('session_not_found');
      }
      final data = snapshot.data()!;
      return WorkoutSession.fromJson(data);
    });
  }

  @override
  Future<void> updateWorkoutSession(WorkoutSession session) async {
    final sessionDoc = _firestore
        .collection(FirestoreConstants.sessionsCollection)
        .doc(session.id);
    await sessionDoc.update(session.toJson());
  }

  @override
  Future<void> deleteWorkoutSession(String sessionId) async {
    final sessionDoc = _firestore
        .collection(FirestoreConstants.sessionsCollection)
        .doc(sessionId);
    await sessionDoc.delete();
  }
}

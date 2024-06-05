import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../constants/constants.dart';
import '../../../../core/api/response.dart';
import '../../../../core/api/result_status.dart';
import '../../../../core/dependency_injection/dependency_injection.dart';
import '../../../../core/error/error_manager.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user.dart';

@lazySingleton
class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore;
  final ErrorManager _errorManager;

  UserRepositoryImpl(
    @Named(firebaseFirestoreInstance) this._firestore,
    this._errorManager,
  );

  @override
  Future<Response<void>> createInitialUserProfile(User user) async {
    try {
      final userProfileExistsResponse = await userProfileExists(user.id);
      if (userProfileExistsResponse.result == ResultStatus.success &&
          !userProfileExistsResponse.data!) {
        await _firestore
            .collection(FirestoreConstants.usersCollection)
            .doc(user.id)
            .set(user.toJson(), SetOptions(merge: true));
      }
      return Response(ResultStatus.success);
    } catch (e, s) {
      return _handleException('failed_to_create_initial_user_profile',
          e: e, s: s);
    }
  }

  Future<Response<void>> updateUserField(
      User user, String field, dynamic value) async {
    try {
      Map<String, dynamic> userData = user.toJson();
      dynamic updateValue = userData[field];
      await _firestore
          .collection(FirestoreConstants.usersCollection)
          .doc(user.id)
          .update({field: updateValue});
      return Response(ResultStatus.success);
    } catch (e, s) {
      return _handleException('failed_to_update_user_field', e: e, s: s);
    }
  }

  Future<Response<void>> _updateUserField(
    String userId,
    String field,
    dynamic value,
    String errorMessage,
  ) async {
    try {
      await _firestore
          .collection(FirestoreConstants.usersCollection)
          .doc(userId)
          .update({field: value});
      return Response(ResultStatus.success);
    } catch (e, s) {
      return _handleException(errorMessage, e: e, s: s);
    }
  }

  Future<Response<bool>> userProfileExists(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(FirestoreConstants.usersCollection)
          .doc(userId)
          .get();
      return Response(ResultStatus.success, data: snapshot.exists);
    } catch (e, s) {
      return _handleException('failed_to_check_user_profile_exists',
          e: e, s: s);
    }
  }

  @override
  Future<Response<bool>> hasCompletedOnboarding(String? userId) async {
    try {
      final doc = await _firestore
          .collection(FirestoreConstants.usersCollection)
          .doc(userId)
          .get();
      bool hasCompleted =
          doc.data()?[FirestoreConstants.hasCompletedOnboardingField] ?? false;
      return Response(ResultStatus.success, data: hasCompleted);
    } catch (e, s) {
      return _handleException('failed_to_check_onboarding_status', e: e, s: s);
    }
  }

  @override
  Future<Response<void>> setOnboardingComplete(String userId) async {
    return _updateUserField(
      userId,
      FirestoreConstants.hasCompletedOnboardingField,
      true,
      'failed_to_set_onboarding_complete',
    );
  }

  Response<T> _handleException<T>(String? message, {Object? e, StackTrace? s}) {
    return _errorManager.handleException(message ?? 'Unknown error',
        exception: e, stackTrace: s);
  }
}

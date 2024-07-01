import 'package:easy_localization/easy_localization.dart';
import 'package:fit_connect/core/state/app_state.dart';
import 'package:injectable/injectable.dart';

import '../../../../constants/constants.dart';
import '../../../../core/api/response.dart';
import '../../../../core/api/result_status.dart';
import '../../../../core/dependency_injection/dependency_injection.dart';
import '../../../../core/error/error_manager.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/remote/user_remote_data_source.dart';
import '../models/user.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final ErrorManager _errorManager;
  final UserRemoteDataSource _remoteDataSource;

  UserRepositoryImpl(
    this._remoteDataSource,
    this._errorManager,
  );

  @override
  Future<Response<void>> createInitialUserProfile(User user) async {
    try {
      final userProfileExistsResponse = await userProfileExists(user.id);
      if (userProfileExistsResponse.result == ResultStatus.success &&
          !userProfileExistsResponse.data!) {
        await _remoteDataSource.createUser(user);
      }
      return Response(ResultStatus.success);
    } catch (e, s) {
      return _handleException('failed_to_create_initial_user_profile',
          e: e, s: s);
    }
  }

  @override
  Future<Response<void>> updateUserField(
      User user, String field, dynamic value) async {
    try {
      Map<String, dynamic> userData = user.toJson();
      dynamic updateValue = userData[field];
      await _remoteDataSource.updateUserField(user.id, field, updateValue);
      return Response(ResultStatus.success);
    } catch (e, s) {
      return _handleException('failed_to_update_user_field', e: e, s: s);
    }
  }

  Future<Response<bool>> userProfileExists(String userId) async {
    try {
      final exists = await _remoteDataSource.userExists(userId);
      return Response(ResultStatus.success, data: exists);
    } catch (e, s) {
      return _handleException('failed_to_check_user_profile_exists',
          e: e, s: s);
    }
  }

  @override
  Future<Response<bool>> hasCompletedOnboarding(String? userId) async {
    try {
      final user = await _remoteDataSource.getUser(userId!);
      bool hasCompleted = user?.hasCompletedOnboarding ?? false;
      return Response(ResultStatus.success, data: hasCompleted);
    } catch (e, s) {
      return _handleException('failed_to_check_onboarding_status', e: e, s: s);
    }
  }

  @override
  Future<Response<void>> setOnboardingComplete(User user) async {
    return updateUserField(
      user,
      FirestoreConstants.hasCompletedOnboardingField,
      true,
    );
  }

  @override
  Future<Response<User>> getUserProfile(String? userId) async {
    try {
      final user = await _remoteDataSource.getUser(userId!);
      if (user != null) {
        return Response(ResultStatus.success, data: user);
      } else {
        return Response(ResultStatus.error, message: "user_not_found".tr());
      }
    } catch (e, s) {
      return _handleException("failed_to_retrieve_user", e: e, s: s);
    }
  }

  @override
  Future<Response<List<User>>> fetchUsers() async {
    try {
      final users = await _remoteDataSource.getAllUsers();
      final currentUser = getIt<AppState>().user;
      users.removeWhere((user) => user.id == currentUser!.id);
      return Response(ResultStatus.success, data: users);
    } catch (e, s) {
      return _handleException<List<User>>("failed_to_fetch_users", e: e, s: s);
    }
  }

  Response<T> _handleException<T>(String? message, {Object? e, StackTrace? s}) {
    return _errorManager.handleException(message ?? 'unknown_error',
        exception: e, stackTrace: s);
  }
}

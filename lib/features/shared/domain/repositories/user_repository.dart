import '../../../../core/api/response.dart';
import '../../data/models/user.dart';

abstract class UserRepository {
  Future<void> createInitialUserProfile(User user);

  Future<Response<bool>> hasCompletedOnboarding(String? userId);

  Future<void> setOnboardingComplete(User user);

  Future<Response<User>> getUserProfile(String? userId);

  Future<Response<void>> updateUserField(
      User user, String field, dynamic value);

  Future<Response<List<User>>> fetchUsers();
}

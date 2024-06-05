import '../../../../core/api/response.dart';
import '../../data/models/user.dart';

abstract class UserRepository {
  Future<void> createInitialUserProfile(User user);

  Future<Response<bool>> hasCompletedOnboarding(String userId);

  Future<void> setOnboardingComplete(String userId);
}

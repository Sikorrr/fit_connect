import '../../models/user.dart';

abstract class UserRemoteDataSource {
  Future<void> createUser(User user);
  Future<void> updateUserField(String userId, String field, dynamic value);
  Future<bool> userExists(String userId);
  Future<User?> getUser(String userId);
  Future<List<User>> getAllUsers();
}

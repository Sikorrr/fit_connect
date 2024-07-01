import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_connect/constants/constants.dart';
import 'package:fit_connect/features/shared/data/datasources/remote/user_remote_data_source.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/dependency_injection/dependency_injection.dart';
import '../../models/user.dart';

@LazySingleton(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore _firestore;

  UserRemoteDataSourceImpl(
    @Named(firebaseFirestoreInstance) this._firestore,
  );

  @override
  Future<void> createUser(User user) async {
    await _firestore
        .collection(FirestoreConstants.usersCollection)
        .doc(user.id)
        .set(user.toJson());
  }

  @override
  Future<void> updateUserField(
      String userId, String field, dynamic value) async {
    await _firestore
        .collection(FirestoreConstants.usersCollection)
        .doc(userId)
        .update({field: value});
  }

  @override
  Future<bool> userExists(String userId) async {
    final doc = await _firestore
        .collection(FirestoreConstants.usersCollection)
        .doc(userId)
        .get();
    return doc.exists;
  }

  @override
  Future<User?> getUser(String userId) async {
    final doc = await _firestore
        .collection(FirestoreConstants.usersCollection)
        .doc(userId)
        .get();
    if (doc.exists) {
      return User.fromJson(doc.data()!);
    }
    return null;
  }

  @override
  Future<List<User>> getAllUsers() async {
    final snapshot =
        await _firestore.collection(FirestoreConstants.usersCollection).get();
    return snapshot.docs.map((doc) => User.fromJson(doc.data())).toList();
  }
}

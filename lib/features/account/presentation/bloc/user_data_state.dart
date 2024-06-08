import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

import '../../../../core/dependency_injection/dependency_injection.dart';
import '../../../shared/data/models/user.dart';
import '../../../shared/domain/repositories/user_repository.dart';

abstract class UserDataState extends Equatable {
  final User user;

  const UserDataState(this.user);

  @override
  List<Object> get props => [user];
}

class InitialUserDataState extends UserDataState {
  const InitialUserDataState({required User user}) : super(user);

  factory InitialUserDataState.fromFirebaseUser(firebase.User firebaseUser) {
    final user = User(id: firebaseUser.uid, email: firebaseUser.email!);
    final initialUserDataState = InitialUserDataState(user: user);
    getIt<UserRepository>().createInitialUserProfile(initialUserDataState.user);
    return initialUserDataState;
  }
}

class UserUpdateState extends UserDataState {
  const UserUpdateState(
    super.user,
  );

  @override
  List<Object> get props => [
        user,
      ];
}

class UserDataFinishedState extends UserDataState {
  const UserDataFinishedState(super.user);

  @override
  List<Object> get props => [user];
}

class UserDataComplete extends UserDataState {
  const UserDataComplete(
    super.user,
  );
}

class UserDataFetched extends UserDataState {
  const UserDataFetched(super.user);
}

class UserDataLoading extends UserDataState {
  const UserDataLoading(super.user);
}

class UserDataError extends UserDataState {
  final String error;

  const UserDataError(this.error, super.user);
}

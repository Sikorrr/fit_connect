import 'package:equatable/equatable.dart';

import '../screens/auth_screen.dart';

abstract class AuthState extends Equatable {
  final AuthScreenType authScreenType;

  const AuthState(this.authScreenType);

  @override
  List<Object?> get props => [authScreenType];
}

class AuthInitialState extends AuthState {
  const AuthInitialState(super.authScreenType);
}

class AuthLoadingState extends AuthState {
  const AuthLoadingState(super.authScreenType);
}

class AuthErrorState extends AuthState {
  final String error;

  const AuthErrorState(super.authScreenType, this.error);
}

class AuthEmailNotVerifiedState extends AuthState {
  const AuthEmailNotVerifiedState(super.authScreenType);
}

class EmailResendSuccessState extends AuthState {
  const EmailResendSuccessState(super.authScreenType);
}

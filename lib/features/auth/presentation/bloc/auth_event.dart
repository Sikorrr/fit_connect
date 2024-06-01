import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmailSignInSubmitted extends AuthEvent {
  final String email;
  final String password;

  EmailSignInSubmitted(this.email, this.password);
}

class ToggleFormType extends AuthEvent {}

class GoogleSignInRequested extends AuthEvent {}

class FacebookSignInRequested extends AuthEvent {}

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

class Logout extends AuthEvent {}

class ResendVerificationEmail extends AuthEvent {
  final bool displayMessage;

  ResendVerificationEmail({this.displayMessage = false});
}

class PasswordResetRequested extends AuthEvent {
  final String email;

  PasswordResetRequested(this.email);
}

class NewPasswordRequested extends AuthEvent {
  final String newPassword;
  final String code;

  NewPasswordRequested({required this.newPassword, required this.code});
}

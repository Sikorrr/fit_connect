import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/api/response.dart';
import '../../../../core/api/result_status.dart';
import '../../domain/repositories/auth_repository.dart';
import '../screens/auth_screen.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository)
      : super(const AuthInitialState(AuthScreenType.login)) {
    on<EmailSignInSubmitted>(_onEmailSignInSubmitted);

    on<ToggleFormType>(_onToggleFormType);

    on<GoogleSignInRequested>(_onGoogleSignInRequested);

    on<FacebookSignInRequested>(_onFacebookSignInRequested);

    on<ResendVerificationEmail>(_onResendVerificationEmail);

    on<PasswordResetRequested>(_onPasswordReset);

    on<NewPasswordRequested>(_newPasswordRequested);

    on<Logout>(_logOut);
  }

  FutureOr<void> _onEmailSignInSubmitted(event, emit) async {
    emit(AuthLoadingState(state.authScreenType));
    Response response = state.authScreenType == AuthScreenType.login
        ? await authRepository.login(event.email, event.password)
        : await authRepository.register(event.email, event.password);
    _handleAuthResponse(response, emit);
  }

  FutureOr<void> _onFacebookSignInRequested(event, emit) async {
    emit(AuthLoadingState(state.authScreenType));
    Response response = await authRepository.loginWithFacebook();
    _handleSocialResponse(response, emit);
  }

  FutureOr<void> _onGoogleSignInRequested(event, emit) async {
    emit(AuthLoadingState(state.authScreenType));
    Response response = await authRepository.loginWithGoogle();
    _handleSocialResponse(response, emit);
  }

  FutureOr<void> _onResendVerificationEmail(
      ResendVerificationEmail event, emit) async {
    Response response = await authRepository.sendVerificationEmail();
    if (response.result == ResultStatus.error) {
      emit(AuthErrorState(state.authScreenType, response.message!));
    } else {
      emit(event.displayMessage
          ? EmailResendSuccessState(state.authScreenType)
          : AuthInitialState(state.authScreenType));
    }
  }

  FutureOr<void> _onToggleFormType(event, emit) {
    AuthScreenType newType = state.authScreenType == AuthScreenType.login
        ? AuthScreenType.register
        : AuthScreenType.login;
    emit(AuthInitialState(newType));
  }

  _handleSocialResponse(Response response, Emitter<AuthState> emit) {
    emit(response.result == ResultStatus.error
        ? AuthErrorState(state.authScreenType, response.message!)
        : AuthInitialState(state.authScreenType));
  }

  void _handleAuthResponse(Response response, Emitter<AuthState> emit) {
    if (response.result == AuthResultStatus.emailNotVerified) {
      if (state.authScreenType == AuthScreenType.register) {
        add(ResendVerificationEmail());
      }
      emit(AuthEmailNotVerifiedState(state.authScreenType));
    } else {
      emit(response.result == ResultStatus.error
          ? AuthErrorState(state.authScreenType, response.message!)
          : AuthInitialState(state.authScreenType));
    }
  }

  Future<FutureOr<void>> _logOut(Logout event, Emitter<AuthState> emit) async {
    await authRepository.logOut();
  }

  FutureOr<void> _onPasswordReset(PasswordResetRequested event, emit) async {
    Response response = await authRepository.resetPassword(event.email);
    emit(response.result == ResultStatus.error
        ? AuthErrorState(state.authScreenType, response.message!)
        : PasswordResetSuccessState(state.authScreenType));
  }

  FutureOr<void> _newPasswordRequested(
      NewPasswordRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState(state.authScreenType));
    Response response = await authRepository.confirmPasswordReset(
        event.code, event.newPassword);
    emit(response.result == ResultStatus.error
        ? AuthErrorState(state.authScreenType, response.message!)
        : PasswordChangedSuccessState(state.authScreenType));
  }
}

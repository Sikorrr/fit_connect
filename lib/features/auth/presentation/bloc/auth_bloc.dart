import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../screens/auth_screen.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepositoryImpl authRepository;

  AuthBloc(this.authRepository)
      : super(const AuthInitialState(AuthScreenType.login)) {
    on<EmailSignInSubmitted>(_onEmailSignInSubmitted);

    on<ToggleFormType>(_onToggleFormType);

    on<GoogleSignInRequested>(_onGoogleSignInRequested);

    on<FacebookSignInRequested>(_onFacebookSignInRequested);
  }

  FutureOr<void> _onEmailSignInSubmitted(event, emit) async {
    emit(AuthLoadingState(state.authScreenType));
    try {
      bool success = state.authScreenType == AuthScreenType.login
          ? await authRepository.login(event.email, event.password)
          : await authRepository.register(event.email, event.password);
      emit(success
          ? AuthInitialState(state.authScreenType)
          : AuthErrorState(state.authScreenType, 'Failed to authenticate'));
    } catch (e) {
      emit(AuthErrorState(state.authScreenType, e.toString()));
    }
  }

  FutureOr<void> _onFacebookSignInRequested(event, emit) async {
    emit(AuthLoadingState(state.authScreenType));
    try {
      bool success = await authRepository.loginWithFacebook();
      emit(success
          ? AuthInitialState(state.authScreenType)
          : AuthErrorState(state.authScreenType, 'Facebook sign-in failed'));
    } catch (e) {
      emit(AuthErrorState(state.authScreenType, e.toString()));
    }
  }

  FutureOr<void> _onGoogleSignInRequested(event, emit) async {
    try {
      emit(AuthLoadingState(state.authScreenType));
      bool success = await authRepository.loginWithGoogle();
      emit(success
          ? AuthInitialState(state.authScreenType)
          : AuthErrorState(state.authScreenType, 'Google sign-in failed'));
    } catch (e) {
      emit(AuthErrorState(state.authScreenType, e.toString()));
    }
  }

  FutureOr<void> _onToggleFormType(event, emit) {
    AuthScreenType newType = state.authScreenType == AuthScreenType.login
        ? AuthScreenType.register
        : AuthScreenType.login;
    emit(AuthInitialState(newType));
  }
}

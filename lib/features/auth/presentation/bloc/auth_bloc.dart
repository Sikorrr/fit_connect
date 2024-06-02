import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/api/response.dart';
import '../../../../core/api/result_status.dart';
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

    on<Logout>(_logOut);
  }

  FutureOr<void> _onEmailSignInSubmitted(event, emit) async {
    emit(AuthLoadingState(state.authScreenType));
    Response response = state.authScreenType == AuthScreenType.login
        ? await authRepository.login(event.email, event.password)
        : await authRepository.register(event.email, event.password);
    _handleResponse(response, emit);
  }

  FutureOr<void> _onFacebookSignInRequested(event, emit) async {
    emit(AuthLoadingState(state.authScreenType));
    Response response = await authRepository.loginWithFacebook();
    _handleResponse(response, emit);
  }

  FutureOr<void> _onGoogleSignInRequested(event, emit) async {
    emit(AuthLoadingState(state.authScreenType));
    Response response = await authRepository.loginWithGoogle();
    _handleResponse(response, emit);
  }

  FutureOr<void> _onToggleFormType(event, emit) {
    AuthScreenType newType = state.authScreenType == AuthScreenType.login
        ? AuthScreenType.register
        : AuthScreenType.login;
    emit(AuthInitialState(newType));
  }

  Future<FutureOr<void>> _logOut(Logout event, Emitter<AuthState> emit) async {
    await authRepository.logOut();
  }

  _handleResponse(Response response, Emitter<AuthState> emit) {
    emit(response.result == ResultStatus.error
        ? AuthErrorState(state.authScreenType, response.message!)
        : AuthInitialState(state.authScreenType));
  }


}

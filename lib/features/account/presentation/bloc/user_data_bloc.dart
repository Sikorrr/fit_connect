import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:fit_connect/features/account/presentation/bloc/user_data_event.dart';
import 'package:fit_connect/features/account/presentation/bloc/user_data_state.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/dependency_injection/dependency_injection.dart';
import '../../../../core/state/app_state.dart';
import '../../../shared/data/models/user.dart';
import '../../../shared/domain/repositories/user_repository.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  final firebase.FirebaseAuth _firebaseAuth;
  final UserRepository _userRepository;

  UserDataBloc(
      @Named(firebaseAuthInstance) this._firebaseAuth, this._userRepository)
      : super(
            InitialUserDataState.fromFirebaseUser(_firebaseAuth.currentUser!)) {
    on<UpdateName>(_updateName);
    on<UpdateAge>(_updateAge);
    on<UpdateGender>(_updateGender);
    on<UpdateFitnessInterests>(_updateFitnessInterests);
    on<UpdateFitnessLevel>(_updateFitnessLevel);
    on<UpdatePreferredWorkoutTimes>(_updatePreferredWorkoutTimes);
    on<UpdatePreferredGender>(_updatePreferredGender);
    on<UpdateAgeRangePreference>(_updateAgeRangePreference);
    on<UpdateLocation>(_updateLocation);
    on<UpdateBio>(_updateBio);
    on<FinishOnboarding>(_finishOnboarding);
    on<FetchUserData>(_onFetchUserData);
  }

  FutureOr<void> _updateName(UpdateName event, Emitter<UserDataState> emit) {
    final user = state.user.copyWith(name: event.name);
    _userRepository.updateUserField(user, 'name', event.name);
    emit(UserUpdateState(user));
  }

  FutureOr<void> _updateAge(UpdateAge event, Emitter<UserDataState> emit) {
    final user = state.user.copyWith(age: event.age);
    _userRepository.updateUserField(user, 'age', event.age);
    emit(UserUpdateState(user));
  }

  FutureOr<void> _updateGender(
      UpdateGender event, Emitter<UserDataState> emit) {
    final user = state.user.copyWith(gender: event.gender);
    _userRepository.updateUserField(user, 'gender', event.gender);
    emit(UserUpdateState(user));
  }

  FutureOr<void> _updateFitnessInterests(
      UpdateFitnessInterests event, Emitter<UserDataState> emit) {
    final user = state.user.copyWith(fitnessInterests: event.fitnessInterests);
    _userRepository.updateUserField(
        user, 'fitnessInterests', event.fitnessInterests);
    emit(UserUpdateState(user));
  }

  FutureOr<void> _updateFitnessLevel(
      UpdateFitnessLevel event, Emitter<UserDataState> emit) {
    final user = state.user.copyWith(fitnessLevel: event.fitnessLevel);
    _userRepository.updateUserField(user, 'fitnessLevel', event.fitnessLevel);
    emit(UserUpdateState(user));
  }

  FutureOr<void> _updatePreferredWorkoutTimes(
      UpdatePreferredWorkoutTimes event, Emitter<UserDataState> emit) {
    final user = state.user
        .copyWith(preferredWorkoutDayTimes: event.preferredWorkoutDayTimes);
    _userRepository.updateUserField(
        user, 'preferredWorkoutDayTimes', event.preferredWorkoutDayTimes);
    emit(UserUpdateState(user));
  }

  FutureOr<void> _updatePreferredGender(
      UpdatePreferredGender event, Emitter<UserDataState> emit) {
    final user =
        state.user.copyWith(preferredGenderOfWorkoutPartner: event.gender);
    _userRepository.updateUserField(
        user, 'preferredGenderOfWorkoutPartner', event.gender);
    emit(UserUpdateState(user));
  }

  FutureOr<void> _updateAgeRangePreference(
      UpdateAgeRangePreference event, Emitter<UserDataState> emit) {
    final user =
        state.user.copyWith(ageRangePreference: event.ageRangePreference);
    _userRepository.updateUserField(
        user, 'ageRangePreference', event.ageRangePreference);
    emit(UserUpdateState(
      user,
    ));
  }

  FutureOr<void> _updateLocation(
      UpdateLocation event, Emitter<UserDataState> emit) {
    final user = state.user.copyWith(location: event.location);
    _userRepository.updateUserField(user, 'location', event.location);
    emit(UserUpdateState(user));
  }

  FutureOr<void> _updateBio(UpdateBio event, Emitter<UserDataState> emit) {
    final user = state.user.copyWith(bio: event.bio);
    _userRepository.updateUserField(user, 'bio', event.bio);
    emit(UserUpdateState(user));
  }

  Future<FutureOr<void>> _finishOnboarding(
      FinishOnboarding event, Emitter<UserDataState> emit) async {
    await _userRepository.setOnboardingComplete(state.user.id);
    emit(UserDataComplete(state.user));
  }

  FutureOr<void> _onFetchUserData(
      FetchUserData event, Emitter<UserDataState> emit) async {
    emit(UserDataLoading(state.user));
    final User? user = getIt<AppState>().user;
    if (user != null) {
      emit(UserDataFetched(user));
    } else {
      emit(UserDataError('failed_to_retrieve_user'.tr(), state.user));
    }
  }
}

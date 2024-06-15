import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../shared/data/models/user.dart';
import '../../../shared/domain/entities/fitness_interest.dart';
import '../../data/models/workout_session.dart';
import 'new_session_state.dart';

class NewSessionCubit extends Cubit<NewSessionState> {
  NewSessionCubit({WorkoutSession? initialSession})
      : super(NewSessionState(
          selectedDate: initialSession?.date.toDate(),
          selectedTime: initialSession != null
              ? TimeOfDay.fromDateTime(initialSession.date.toDate())
              : null,
          selectedActivity: initialSession?.activity,
          location: initialSession?.place ?? '',
          errorMessage: null,
          initialSession: initialSession,
        ));

  void setDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  void setTime(TimeOfDay time) {
    emit(state.copyWith(selectedTime: time));
  }

  void setActivity(FitnessInterest activity) {
    emit(state.copyWith(selectedActivity: activity));
  }

  void setLocation(String location) {
    emit(state.copyWith(location: location));
  }

  void validateAndSubmit(User user, User appStateUser, Function onSubmit) {
    if (state.selectedActivity == null) {
      emit(state.copyWith(errorMessage: 'please_select_activity'.tr()));
      return;
    }

    if (state.selectedDate == null) {
      emit(state.copyWith(errorMessage: 'please_select_date'.tr()));
      return;
    }

    if (state.selectedTime == null) {
      emit(state.copyWith(errorMessage: 'please_select_time'.tr()));
      return;
    }

    final combinedDateTime = DateTime(
      state.selectedDate!.year,
      state.selectedDate!.month,
      state.selectedDate!.day,
      state.selectedTime!.hour,
      state.selectedTime!.minute,
    );

    final workoutSession = WorkoutSession(
      id: state.initialSession?.id ?? '',
      activity: state.selectedActivity!,
      date: Timestamp.fromDate(combinedDateTime),
      participantIds: [
        user.id,
        appStateUser.id,
      ],
      place: state.location,
    );

    onSubmit(workoutSession);
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:fit_connect/features/shared/domain/entities/fitness_interest.dart';
import 'package:fit_connect/features/workout_session/presentation/bloc/workout_session_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/alerts/alert_service.dart';
import '../../../core/dependency_injection/dependency_injection.dart';
import '../features/shared/data/models/user.dart';
import '../features/workout_session/data/models/workout_session.dart';
import '../features/workout_session/presentation/bloc/workout_session_state.dart';
import '../features/workout_session/presentation/screens/new_session_screen.dart';

void showSessionDialog(BuildContext context,
    {WorkoutSession? initialSession,
    required User user,
    required List<FitnessInterest> availableActivities}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: BlocListener<WorkoutSessionBloc, WorkoutSessionState>(
          listener: (BuildContext context, state) {
            if (state is WorkoutSessionAdded) {
              getIt<AlertService>().showMessage(
                  context,
                  'workout_session_successfully_created'.tr(),
                  MessageType.success);
            } else if (state is WorkoutSessionError) {
              getIt<AlertService>()
                  .showMessage(context, state.message, MessageType.error);
            }
          },
          child: NewSessionScreen(
            availableActivities: availableActivities,
            user: user,
            initialSession: initialSession,
          ),
        ),
      );
    },
  );
}

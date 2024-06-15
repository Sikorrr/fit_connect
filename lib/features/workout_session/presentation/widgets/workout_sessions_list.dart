import 'package:easy_localization/easy_localization.dart';
import 'package:fit_connect/features/workout_session/presentation/widgets/workout_card_small.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/alerts/alert_service.dart';
import '../../../../core/dependency_injection/dependency_injection.dart';
import '../../../../utils/image_utils.dart';
import '../bloc/workout_session_bloc.dart';
import '../bloc/workout_session_event.dart';
import '../bloc/workout_session_state.dart';

class WorkoutSessionsList extends StatelessWidget {
  final bool fetchPast;

  const WorkoutSessionsList({super.key, required this.fetchPast});

  static const double imageSize = 80.0;

  @override
  Widget build(BuildContext context) {
    context
        .read<WorkoutSessionBloc>()
        .add(FetchAllWorkoutSessionsEvent(fetchPast: fetchPast));
    return BlocConsumer<WorkoutSessionBloc, WorkoutSessionState>(
      builder: (BuildContext context, state) {
        if (state is WorkoutSessionLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is WorkoutSessionLoaded) {
          if (state.sessions.isEmpty) {
            return Center(
              child: Text(
                fetchPast
                    ? 'no_past_workouts'.tr()
                    : 'no_upcoming_workouts'.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            );
          }
          return ListView.builder(
            itemCount: state.sessions.length,
            itemBuilder: (context, index) {
              String imagePath = getImagePath(index);
              final workout = state.sessions[index];
              return WorkoutCardSmall(
                  workout: workout, imagePath: imagePath, fetchPast: fetchPast);
            },
          );
        }
        return const SizedBox.shrink();
      },
      listener: (BuildContext context, WorkoutSessionState state) {
        if (state is WorkoutSessionRemoved) {
          getIt<AlertService>().showMessage(
              context, 'workout_session_removed'.tr(), MessageType.success);
        } else if (state is WorkoutSessionUpdated) {
          getIt<AlertService>().showMessage(
              context, 'workout_session_updated'.tr(), MessageType.success);
        } else if (state is WorkoutSessionCompleted) {
          getIt<AlertService>().showMessage(
              context, 'workout_session_completed'.tr(), MessageType.success);
        } else if (state is WorkoutSessionError) {
          getIt<AlertService>().showMessage(
              context,
              '${'workout_session_error'.tr()} ${state.message}',
              MessageType.error);
        }
      },
    );
  }
}

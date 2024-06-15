import 'package:fit_connect/features/shared/domain/repositories/user_repository.dart';
import 'package:fit_connect/features/workout_session/presentation/bloc/workout_session_event.dart';
import 'package:fit_connect/features/workout_session/presentation/bloc/workout_session_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/dependency_injection/dependency_injection.dart';
import '../../domain/repositories/workout_session_repository.dart';
import '../bloc/workout_session_bloc.dart';
import '../widgets/workout_session_content.dart';

class UpcomingWorkoutsSection extends StatelessWidget {
  const UpcomingWorkoutsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkoutSessionBloc(
        getIt<WorkoutSessionRepository>(),
        getIt<UserRepository>(),
      )..add(const FetchAllWorkoutSessionsEvent(limit: 3)),
      child: BlocBuilder<WorkoutSessionBloc, WorkoutSessionState>(
        builder: (context, state) {
          if (state is WorkoutSessionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WorkoutSessionLoaded) {
            return WorkoutSectionContent(state: state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

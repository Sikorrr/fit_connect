import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../common_widgets/custom_button.dart';
import '../../../../common_widgets/responsive_center.dart';
import '../../../../constants/style_guide.dart';
import '../../../../core/dependency_injection/dependency_injection.dart';
import '../../../../core/state/app_state.dart';
import '../../../shared/data/models/user.dart';
import '../../../shared/domain/entities/fitness_interest.dart';
import '../../data/models/workout_session.dart';
import '../bloc/workout_session_bloc.dart';
import '../bloc/workout_session_event.dart';
import '../cubit/new_session_cubit.dart';
import '../cubit/new_session_state.dart';
import '../widgets/activity_dropdown.dart';
import '../widgets/date_tile.dart';
import '../widgets/error_message.dart';
import '../widgets/location_field.dart';
import '../widgets/time_tile.dart';

class NewSessionScreen extends StatelessWidget {
  final List<FitnessInterest> availableActivities;
  final User user;
  final WorkoutSession? initialSession;

  const NewSessionScreen({
    super.key,
    required this.availableActivities,
    required this.user,
    this.initialSession,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NewSessionCubit(initialSession: initialSession),
      child: ResponsiveCenter(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: BlocBuilder<NewSessionCubit, NewSessionState>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DateTile(
                    selectedDate: state.selectedDate,
                    onDateSelected: (date) {
                      context.read<NewSessionCubit>().setDate(date!);
                    },
                  ),
                  TimeTile(
                    selectedTime: state.selectedTime,
                    onTimeSelected: (time) {
                      context.read<NewSessionCubit>().setTime(time!);
                    },
                  ),
                  ActivityDropdown(
                    availableActivities: availableActivities,
                    selectedActivity: state.selectedActivity,
                    onActivityChanged: (activity) {
                      context.read<NewSessionCubit>().setActivity(activity!);
                    },
                  ),
                  LocationField(
                    controller: TextEditingController(text: state.location),
                    onChanged: (location) {
                      context.read<NewSessionCubit>().setLocation(location);
                    },
                  ),
                  const Gap(Sizes.p24),
                  if (state.errorMessage != null)
                    ErrorMessage(errorMessage: state.errorMessage!),
                  CustomButton(
                    onPressed: () => _handleOnPressed(context),
                    label: 'save'.tr(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleOnPressed(BuildContext context) {
    context.read<NewSessionCubit>().validateAndSubmit(
      user,
      getIt<AppState>().user!,
      (workoutSession) {
        if (initialSession == null) {
          BlocProvider.of<WorkoutSessionBloc>(context).add(
            AddWorkoutSessionEvent(workoutSession: workoutSession),
          );
        } else {
          BlocProvider.of<WorkoutSessionBloc>(context).add(
            EditWorkoutSessionEvent(workoutSession),
          );
        }
        Navigator.pop(context);
      },
    );
  }
}

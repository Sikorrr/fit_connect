import 'package:easy_localization/easy_localization.dart';
import 'package:fit_connect/features/shared/domain/entities/fitness_interest.dart';
import 'package:fit_connect/features/workout_session/presentation/bloc/workout_session_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../constants/style_guide.dart';
import '../../../../utils/date_utils.dart';
import '../../../../utils/dialog_utils.dart';
import '../../data/models/workout_session.dart';
import '../bloc/workout_session_event.dart';

class WorkoutCardSmall extends StatelessWidget {
  const WorkoutCardSmall(
      {super.key,
      required this.workout,
      required this.imagePath,
      required this.fetchPast});

  final WorkoutSession workout;
  final String imagePath;
  final bool fetchPast;
  static const double imageSize = 80.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin:
          const EdgeInsets.symmetric(horizontal: Sizes.p16, vertical: Sizes.p8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.defaultRadius),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(Sizes.p8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(Sizes.defaultRadius),
          child: Image.asset(
            imagePath,
            width: imageSize,
            height: imageSize,
            fit: BoxFit.cover,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (fetchPast && !workout.isCompleted)
              IconButton(
                icon: Icon(Icons.check_circle,
                    color: Colors.greenAccent.withOpacity(0.8)),
                onPressed: () {
                  _showCompleteDialog(context);
                },
              ),
            if (!fetchPast)
              IconButton(
                icon: Icon(Icons.edit,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.8)),
                onPressed: () {
                  _showEditDialog(context);
                },
              ),
            IconButton(
              icon: Icon(Icons.delete,
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.8)),
              onPressed: () {
                _showDeleteDialog(context);
              },
            ),
          ],
        ),
        title: Text(
          '${formatWorkoutDate(workout.date)} ${'at'.tr()} ${formatTimestamp(workout.date)}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              workout.activity.displayName,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '${'with_user'.tr()}: ${workout.otherUser?.name}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (workout.place != null && workout.place!.isNotEmpty)
              Row(
                children: [
                  const Icon(Icons.place,
                      size: Sizes.iconSize, color: Sizes.iconColor),
                  const Gap(Sizes.p4),
                  Text(
                    workout.place!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _showCompleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('confirm_complete'.tr()),
          content: Text('are_you_sure_complete'.tr()),
          actions: [
            TextButton(
              child: Text('cancel'.tr()),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
            TextButton(
              child: Text('complete'.tr()),
              onPressed: () {
                context
                    .read<WorkoutSessionBloc>()
                    .add(CompleteWorkoutSessionEvent(workout));
                Navigator.pop(dialogContext);
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('confirm_delete'.tr()),
          content: Text('are_you_sure_delete'.tr()),
          actions: [
            TextButton(
              child: Text('cancel'.tr()),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
            TextButton(
              child: Text('delete'.tr()),
              onPressed: () {
                context
                    .read<WorkoutSessionBloc>()
                    .add(RemoveWorkoutSessionEvent(workout.id!));
                Navigator.pop(dialogContext);
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context) {
    showSessionDialog(
      context,
      user: workout.otherUser!,
      availableActivities: workout.otherUser!.fitnessInterests,
      initialSession: workout,
    );
  }
}

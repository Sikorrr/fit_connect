import 'package:easy_localization/easy_localization.dart';
import 'package:fit_connect/features/shared/domain/entities/fitness_interest.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../constants/style_guide.dart';
import '../../../../utils/date_utils.dart';
import '../../data/models/workout_session.dart';

class WorkoutCardMain extends StatelessWidget {
  final WorkoutSession workout;

  final String imagePath;
  static const double imageHeight = 150.0;
  const WorkoutCardMain(
      {super.key, required this.workout, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: Sizes.defaultElevation,
      margin: const EdgeInsets.only(bottom: Sizes.p12, left: Sizes.p8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.defaultRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(Sizes.defaultRadius)),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: imageHeight,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(Sizes.p12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: Sizes.iconSize, color: Colors.grey),
                        const Gap(Sizes.p4),
                        Text(
                          '${formatWorkoutDate(workout.date)} ${'at'.tr()} ${formatTimestamp(workout.date)}',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const Gap(Sizes.p4),
                    Text(
                      workout.activity.displayName,
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    const Gap(Sizes.p4),
                    Text(
                      '${'with_user'.tr()}: ${workout.otherUser?.name}',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    const Gap(Sizes.p4),
                    if (workout.place != null && workout.place!.isNotEmpty)
                      Row(
                        children: [
                          const Icon(Icons.place,
                              size: Sizes.iconSize, color: Colors.grey),
                          const Gap(Sizes.p4),
                          Text(
                            workout.place!,
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

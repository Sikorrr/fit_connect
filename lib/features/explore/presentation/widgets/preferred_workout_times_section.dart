import 'package:easy_localization/easy_localization.dart';
import 'package:fit_connect/features/shared/domain/entities/workout_day.dart';
import 'package:fit_connect/features/shared/domain/entities/workout_time.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../constants/style_guide.dart';
import '../../../shared/domain/entities/workout_day_times.dart';

class PreferredWorkoutTimesSection extends StatelessWidget {
  final List<WorkoutDayTimes> preferredWorkoutDayTimes;

  const PreferredWorkoutTimesSection({
    super.key,
    required this.preferredWorkoutDayTimes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'preferred_workout_times'.tr(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const Gap(Sizes.p8),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(3),
          },
          children: preferredWorkoutDayTimes.map((workoutDayTimes) {
            return TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: Sizes.p12),
                  child: Text(
                    workoutDayTimes.day.displayName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Wrap(
                  spacing: Sizes.chipSpacing,
                  runSpacing: Sizes.chipRunSpacing,
                  children: workoutDayTimes.times.map((time) {
                    return Chip(
                      labelPadding: EdgeInsets.zero,
                      label: Text(time.displayName,
                          style: Theme.of(context).textTheme.bodySmall),
                      backgroundColor: Colors.transparent,
                    );
                  }).toList(),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

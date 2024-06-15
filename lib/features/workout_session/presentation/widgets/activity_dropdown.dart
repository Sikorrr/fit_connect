import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../shared/domain/entities/fitness_interest.dart';

class ActivityDropdown extends StatelessWidget {
  final List<FitnessInterest> availableActivities;
  final FitnessInterest? selectedActivity;
  final ValueChanged<FitnessInterest?> onActivityChanged;

  const ActivityDropdown({
    super.key,
    required this.availableActivities,
    required this.selectedActivity,
    required this.onActivityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<FitnessInterest>(
      value: selectedActivity,
      items: availableActivities
          .map((activity) => DropdownMenuItem<FitnessInterest>(
                value: activity,
                child: Text(activity.displayName),
              ))
          .toList(),
      onChanged: onActivityChanged,
      decoration: InputDecoration(
        labelText: 'activity'.tr(),
        icon: const Icon(Icons.fitness_center),
      ),
    );
  }
}

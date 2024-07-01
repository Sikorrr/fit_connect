import 'package:fit_connect/features/account/presentation/widgets/user_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/domain/entities/workout_day.dart';
import '../../../shared/domain/entities/workout_day_times.dart';
import '../../../shared/domain/entities/workout_time.dart';
import '../cubit/multi_select_daytime_cubit.dart';

class MultiSelectDayTimeWidget extends StatelessWidget {
  final Function(List<WorkoutDayTimes>) onSelected;
  final List<WorkoutDayTimes> initialSelectedItems;
  final List<WorkoutDay> availableDays;
  final List<WorkoutTime> availableTimes;
  final String title;
  final bool isEditing;

  const MultiSelectDayTimeWidget({
    super.key,
    required this.onSelected,
    required this.initialSelectedItems,
    required this.availableDays,
    required this.availableTimes,
    required this.title,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return MultiSelectDayTimeCubit(
          initialSelectedItems: initialSelectedItems,
          availableDays: availableDays,
          availableTimes: availableTimes,
        );
      },
      child: BlocBuilder<MultiSelectDayTimeCubit, MultiSelectDayTimeState>(
        builder: (context, state) {
          return UserInput(
            isFullscreen: true,
            title: title,
            onPressed: () {
              final selectedItems =
                  context.read<MultiSelectDayTimeCubit>().getSelectedItems();
              onSelected(selectedItems);
            },
            isEditing: isEditing,
            child: ListView(
              children: availableDays.map((day) {
                return ExpansionTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(day.displayName),
                      Checkbox(
                        value: state.allDaySelected[day],
                        onChanged: (value) {
                          context
                              .read<MultiSelectDayTimeCubit>()
                              .toggleAllDaySelection(day);
                        },
                      ),
                    ],
                  ),
                  children: availableTimes.map((time) {
                    final isSelected =
                        state.selectedItems[day]?.contains(time) ?? false;
                    return CheckboxListTile(
                      title: Text(time.displayName),
                      value: isSelected,
                      onChanged: (value) {
                        context
                            .read<MultiSelectDayTimeCubit>()
                            .toggleSelection(day, time);
                      },
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}

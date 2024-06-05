import 'package:fit_connect/features/account/presentation/widgets/user_input.dart';
import 'package:flutter/material.dart';

import '../../../shared/domain/entities/workout_day.dart';
import '../../../shared/domain/entities/workout_day_times.dart';
import '../../../shared/domain/entities/workout_time.dart';

class MultiSelectDayTimeWidget extends StatefulWidget {
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
  State<MultiSelectDayTimeWidget> createState() =>
      _MultiSelectDayTimeWidgetState();
}

class _MultiSelectDayTimeWidgetState extends State<MultiSelectDayTimeWidget> {
  late Map<WorkoutDay, List<WorkoutTime>> selectedItems;
  late Map<WorkoutDay, bool> allDaySelected;

  @override
  void initState() {
    super.initState();
    selectedItems = {
      for (var day in widget.availableDays)
        day: widget.initialSelectedItems
            .where((item) => item.day == day)
            .expand((item) => item.times)
            .toList(),
    };
    allDaySelected = {
      for (var day in widget.availableDays)
        day: selectedItems[day]?.length == widget.availableTimes.length,
    };
  }

  void toggleSelection(WorkoutDay day, WorkoutTime time) {
    setState(() {
      final times = selectedItems[day] ?? [];
      if (times.contains(time)) {
        times.remove(time);
      } else {
        times.add(time);
      }
      selectedItems[day] = times;
      allDaySelected[day] = times.length == widget.availableTimes.length;
    });
  }

  void toggleAllDaySelection(WorkoutDay day) {
    setState(() {
      if (allDaySelected[day]!) {
        selectedItems[day] = [];
      } else {
        selectedItems[day] = List.from(widget.availableTimes);
      }
      allDaySelected[day] = !allDaySelected[day]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return UserInput(
      isFullscreen: true,
      title: widget.title,
      onPressed: () {
        final selectedList = selectedItems.entries
            .where((entry) => entry.value.isNotEmpty)
            .map((entry) => WorkoutDayTimes(day: entry.key, times: entry.value))
            .toList();
        widget.onSelected(selectedList);
      },
      isEditing: widget.isEditing,
      child: ListView(
        children: widget.availableDays.map((day) {
          return ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(day.displayName),
                Checkbox(
                  value: allDaySelected[day],
                  onChanged: (value) {
                    toggleAllDaySelection(day);
                  },
                ),
              ],
            ),
            children: widget.availableTimes.map((time) {
              final isSelected = selectedItems[day]?.contains(time) ?? false;
              return CheckboxListTile(
                title: Text(time.displayName),
                value: isSelected,
                onChanged: (value) => toggleSelection(day, time),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/domain/entities/workout_day.dart';
import '../../../shared/domain/entities/workout_day_times.dart';
import '../../../shared/domain/entities/workout_time.dart';

class MultiSelectDayTimeState {
  final Map<WorkoutDay, List<WorkoutTime>> selectedItems;
  final Map<WorkoutDay, bool> allDaySelected;

  MultiSelectDayTimeState({
    required this.selectedItems,
    required this.allDaySelected,
  });

  MultiSelectDayTimeState copyWith({
    Map<WorkoutDay, List<WorkoutTime>>? selectedItems,
    Map<WorkoutDay, bool>? allDaySelected,
  }) {
    return MultiSelectDayTimeState(
      selectedItems: selectedItems ?? this.selectedItems,
      allDaySelected: allDaySelected ?? this.allDaySelected,
    );
  }
}

class MultiSelectDayTimeCubit extends Cubit<MultiSelectDayTimeState> {
  final List<WorkoutDay> availableDays;
  final List<WorkoutTime> availableTimes;

  MultiSelectDayTimeCubit({
    required List<WorkoutDayTimes> initialSelectedItems,
    required this.availableDays,
    required this.availableTimes,
  }) : super(MultiSelectDayTimeState(
          selectedItems: {
            for (var day in availableDays)
              day: initialSelectedItems
                  .where((item) => item.day == day)
                  .expand((item) => item.times)
                  .toList(),
          },
          allDaySelected: {
            for (var day in availableDays)
              day: initialSelectedItems
                      .where((item) => item.day == day)
                      .expand((item) => item.times)
                      .length ==
                  availableTimes.length,
          },
        ));

  void toggleSelection(WorkoutDay day, WorkoutTime time) {
    final times = List<WorkoutTime>.from(state.selectedItems[day] ?? []);
    if (times.contains(time)) {
      times.remove(time);
    } else {
      times.add(time);
    }
    final updatedItems = {...state.selectedItems, day: times};
    final updatedAllDaySelected = {
      ...state.allDaySelected,
      day: times.length == availableTimes.length,
    };
    emit(state.copyWith(
      selectedItems: updatedItems,
      allDaySelected: updatedAllDaySelected,
    ));
  }

  void toggleAllDaySelection(WorkoutDay day) {
    final allDaySelected = state.allDaySelected[day] ?? false;
    final updatedItems = {
      ...state.selectedItems,
      day: allDaySelected
          ? <WorkoutTime>[]
          : List<WorkoutTime>.from(availableTimes),
    };
    final updatedAllDaySelected = {
      ...state.allDaySelected,
      day: !allDaySelected,
    };
    emit(state.copyWith(
      selectedItems: updatedItems,
      allDaySelected: updatedAllDaySelected,
    ));
  }

  List<WorkoutDayTimes> getSelectedItems() {
    return state.selectedItems.entries
        .where((entry) => entry.value.isNotEmpty)
        .map((entry) => WorkoutDayTimes(day: entry.key, times: entry.value))
        .toList();
  }
}

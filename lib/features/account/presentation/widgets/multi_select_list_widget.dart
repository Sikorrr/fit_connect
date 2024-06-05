import 'package:fit_connect/features/account/presentation/widgets/selection_list_tile.dart';
import 'package:fit_connect/features/account/presentation/widgets/user_input.dart';
import 'package:flutter/material.dart';

class MultiSelectListWidget<T> extends StatefulWidget {
  final Function(List<T>) onSelected;
  final List<T> initialSelectedItems;
  final List<T> availableOptions;
  final String title;
  final bool isEditing;
  final List<String> displayNames;

  const MultiSelectListWidget({
    super.key,
    required this.onSelected,
    required this.initialSelectedItems,
    required this.availableOptions,
    required this.displayNames,
    required this.title,
    this.isEditing = false,
  });

  @override
  State<MultiSelectListWidget<T>> createState() =>
      _MultiSelectListWidgetState<T>();
}

class _MultiSelectListWidgetState<T> extends State<MultiSelectListWidget<T>> {
  late Map<T, bool> selectedItems;
  late List<T> selectedList;

  @override
  void initState() {
    super.initState();
    selectedItems = {
      for (var item in widget.availableOptions)
        item: widget.initialSelectedItems.contains(item),
    };
    selectedList = selectedItems.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }

  void toggleSelection(T item) {
    setState(() {
      selectedItems[item] = !selectedItems[item]!;
      selectedList = selectedItems.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return UserInput(
      isFullscreen: true,
      title: widget.title,
      onPressed: selectedList.isNotEmpty
          ? () => widget.onSelected(selectedList)
          : null,
      isEditing: widget.isEditing,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.availableOptions.length,
        itemBuilder: (context, index) {
          T item = widget.availableOptions[index];
          bool isSelected = selectedItems[item]!;
          String displayName = widget.displayNames[index];
          return SelectionListTile<T>(
            item: item,
            displayName: displayName,
            trailing: isSelected
                ? Icon(Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary)
                : const Icon(Icons.check_circle_outline, color: Colors.grey),
            isSelected: isSelected,
            onItemSelected: (value) {
              if (value != null) {
                toggleSelection(value);
              }
            },
          );
        },
      ),
    );
  }
}

import 'package:fit_connect/features/account/presentation/widgets/selection_list_tile.dart';
import 'package:fit_connect/features/account/presentation/widgets/user_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SingleSelectListWidget<T> extends HookWidget {
  final Function(T) onItemSelected;
  final String title;
  final List<T> items;
  final T? initialSelectedItem;
  final List<String> displayNames;
  final bool isEditing;

  const SingleSelectListWidget({
    super.key,
    required this.onItemSelected,
    required this.title,
    required this.items,
    required this.displayNames,
    this.initialSelectedItem,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context) {
    final selectedItem = useState<T?>(initialSelectedItem);

    return UserInput(
      title: title,
      onPressed: selectedItem.value != null
          ? () => onItemSelected(selectedItem.value!)
          : null,
      isEditing: isEditing,
      child: ListView.builder(
        itemCount: items.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final item = items[index];
          final displayName = displayNames[index];
          return SelectionListTile<T>(
            item: item,
            displayName: displayName,
            isSelected: item == selectedItem.value,
            onItemSelected: (value) {
              selectedItem.value = value;
            },
          );
        },
      ),
    );
  }
}

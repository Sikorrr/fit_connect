import 'package:flutter/material.dart';

class SelectionListTile<T> extends StatelessWidget {
  final T item;
  final String displayName;
  final bool isSelected;
  final ValueChanged<T?> onItemSelected;

  final Widget? trailing;

  const SelectionListTile(
      {super.key,
      required this.item,
      required this.displayName,
      required this.isSelected,
      required this.onItemSelected,
      this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(displayName),
      trailing: trailing,
      leading: trailing != null
          ? null
          : Radio<T>(
              value: item,
              groupValue: isSelected ? item : null,
              onChanged: onItemSelected,
            ),
      onTap: () => onItemSelected(item),
      selected: isSelected,
      selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
    );
  }
}

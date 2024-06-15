import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DateTile extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onDateSelected;

  const DateTile({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  Future<void> _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      onDateSelected(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.calendar_today),
      title: Text('date'.tr()),
      subtitle: Text(
        selectedDate != null
            ? DateFormat.yMd().format(selectedDate!)
            : 'please_select_date'.tr(),
      ),
      onTap: () => _pickDate(context),
    );
  }
}

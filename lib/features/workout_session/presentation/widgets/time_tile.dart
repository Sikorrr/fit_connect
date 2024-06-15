import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TimeTile extends StatelessWidget {
  final TimeOfDay? selectedTime;
  final ValueChanged<TimeOfDay?> onTimeSelected;

  const TimeTile({
    super.key,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  Future<void> _pickTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      onTimeSelected(pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.access_time),
      title: Text('time'.tr()),
      subtitle: Text(
        selectedTime != null
            ? selectedTime!.format(context)
            : 'please_select_time'.tr(),
      ),
      onTap: () => _pickTime(context),
    );
  }
}

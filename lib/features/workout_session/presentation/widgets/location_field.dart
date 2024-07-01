import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LocationField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final String? initialValue;

  const LocationField({super.key, required this.onChanged, this.initialValue});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: 'location'.tr(),
        icon: const Icon(Icons.location_on),
      ),
    );
  }
}

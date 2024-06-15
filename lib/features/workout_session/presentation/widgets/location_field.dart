import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LocationField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const LocationField(
      {super.key, required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: 'location'.tr(),
        icon: const Icon(Icons.location_on),
      ),
    );
  }
}

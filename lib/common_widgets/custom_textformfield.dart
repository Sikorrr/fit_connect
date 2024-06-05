import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.validator,
    this.obscureText = false,
    this.autofocus = false,
    this.onChanged,
    this.initialValue,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.autovalidateMode,
  });

  final TextEditingController? controller;
  final FormFieldValidator? validator;
  final String? label;
  final String? hint;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final String? initialValue;
  final TextCapitalization textCapitalization;
  final TextInputType? keyboardType;
  final AutovalidateMode? autovalidateMode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      autofocus: autofocus,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText,
      autovalidateMode: autovalidateMode,
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

import 'package:fit_connect/features/account/presentation/widgets/user_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../common_widgets/custom_textformfield.dart';

class TextInputWidget extends HookWidget {
  const TextInputWidget({
    super.key,
    required this.text,
    required this.onChanged,
    required this.initialValue,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType,
    this.validator,
    this.isEditing = false,
  });

  final String text;
  final ValueChanged<String> onChanged;
  final String? initialValue;
  final TextCapitalization textCapitalization;
  final TextInputType? keyboardType;
  final FormFieldValidator? validator;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: initialValue);
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);
    final isButtonEnabled =
        useState<bool>(validator == null || controller.text.isNotEmpty);
    return UserInput(
      title: text,
      onPressed: isButtonEnabled.value
          ? () {
              onChanged(controller.text);
            }
          : null,
      isEditing: isEditing,
      child: Form(
        key: formKey,
        child: CustomTextFormField(
          controller: controller,
          autofocus: true,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (_) {
            isButtonEnabled.value = formKey.currentState?.validate() ?? false;
          },
        ),
      ),
    );
  }
}

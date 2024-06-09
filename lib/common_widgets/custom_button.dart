import 'package:flutter/material.dart';

import '../constants/style_guide.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.onPressed,
      required this.label,
      this.color,
      this.isLoading = false});

  final VoidCallback? onPressed;
  final String label;
  final bool isLoading;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                return Theme.of(context).colorScheme.primary.withOpacity(0.5);
              }
              return color ?? Theme.of(context).colorScheme.primary;
            },
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                width: Sizes.p16,
                height: Sizes.p16,
                child: CircularProgressIndicator(
                  strokeWidth: Sizes.defaultStrokeWidth,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              )
            : Text(
                label,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../constants/sizes.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.onPressed,
      required this.label,
      this.isLoading = false});

  final VoidCallback onPressed;
  final String label;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: Sizes.p16,
                height: Sizes.p16,
                child: CircularProgressIndicator(
                  strokeWidth: Sizes.defaultStrokeWidth,
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

import 'package:flutter/material.dart';

import '../constants/style_guide.dart';

class LinkedText extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  const LinkedText({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(Sizes.defaultRadius),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Sizes.p12, vertical: Sizes.p4),
          child: Text(
            text,
            style: TextStyle(
                decoration: TextDecoration.underline,
                color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
    );
  }
}

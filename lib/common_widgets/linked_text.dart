import 'package:flutter/material.dart';

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
    return InkWell(
      onTap: onPressed,
      child: Text(
        text,
        style: TextStyle(
            decoration: TextDecoration.underline,
            color: Theme.of(context).colorScheme.inversePrimary),
      ),
    );
  }
}

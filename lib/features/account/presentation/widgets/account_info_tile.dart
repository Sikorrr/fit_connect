import 'package:flutter/material.dart';

class AccountInfoTile extends StatelessWidget {
  const AccountInfoTile(
      {super.key, required this.title, required this.value, this.onPressed});

  final String title;
  final String value;

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      trailing: onPressed != null
          ? IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onPressed,
            )
          : null,
    );
  }
}

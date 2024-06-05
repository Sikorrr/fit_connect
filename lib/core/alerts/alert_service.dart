import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

enum MessageType {
  success,
  error,
}

abstract class AlertService {
  void showMessage(BuildContext context, String message, MessageType type);
}

@Singleton(as: AlertService)
class SnackBarAlertService implements AlertService {
  @override
  void showMessage(BuildContext context, String message, MessageType type) {
    Color backgroundColor;
    switch (type) {
      case MessageType.success:
        backgroundColor = Colors.green;
        break;
      case MessageType.error:
        backgroundColor = Theme.of(context).colorScheme.error;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }
}

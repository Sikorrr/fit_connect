import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'api/response.dart';
import 'api/result_status.dart';

abstract class ErrorManager {
  void initialize();

  void logError(String message, {dynamic exception, StackTrace? stackTrace});

  Response<T> handleException<T>(String message,
      {Object? exception, StackTrace? stackTrace});
}

@Singleton(as: ErrorManager)
class CrashlyticsErrorManager implements ErrorManager {
  @override
  void initialize() {
    if (!kIsWeb) {
      FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    }
  }

  @override
  void logError(String message, {dynamic exception, StackTrace? stackTrace}) {
    FirebaseCrashlytics.instance.recordError(
        exception ?? Exception(message), stackTrace,
        reason: message);
    debugPrint('$message, $exception, $stackTrace');
  }

  String getErrorMessage(FirebaseException e) {
    switch (e.code) {
      case 'invalid-credential':
        return 'invalid_credential';
      case 'email-already-in-use':
        return 'email_already_in_use';
      case 'network-request-failed':
        return 'network_request_failed';
      case 'too-many-requests':
        return 'too_many_requests';
      case 'invalid-action-code':
        return 'invalid_action_code';
      default:
        return 'unknown_error';
    }
  }

  String getUserFriendlyMessage(String key) {
    return tr(key);
  }

  @override
  Response<T> handleException<T>(String message,
      {Object? exception, StackTrace? stackTrace}) {
    logError(message, exception: exception, stackTrace: stackTrace);
    final errorMessage =
        exception is FirebaseException ? getErrorMessage(exception) : message;
    return Response<T>(ResultStatus.error,
        message: getUserFriendlyMessage(errorMessage));
  }
}

class AppErrorManager {
  static late ErrorManager _errorManager;

  static void initialize(ErrorManager errorManager) {
    _errorManager = errorManager;
    _errorManager.initialize();

    FlutterError.onError = (FlutterErrorDetails details) {
      String message = '${details.exception.runtimeType}: ${details.exception}';
      _errorManager.logError(message,
          exception: details.exception, stackTrace: details.stack);
    };
  }

  static void logError(dynamic error, {StackTrace? stackTrace}) {
    _errorManager.logError(error, stackTrace: stackTrace);
  }
}

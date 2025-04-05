import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '_exceptions.dart';

class ErrorLogger {
  final _log = Logger();

  /// This method will separate the error object to be processed by certain methods for a certain object.
  void log(Object error, StackTrace? stackTrace) =>
      (error is AppException) ? _logAppException(error) : _logError(error, stackTrace);

  void _logError(Object error, StackTrace? stackTrace) {
    // * Optional to be replaced with a crash reporting tool. (Sentry, Crashlytics, etc.)
    if (kReleaseMode) {
      // TODO Watchout
    }

    // Fatal level since it isn't recognized as a defined AppException.
    _log.f('ERROR', error: error, stackTrace: stackTrace);
  }

  void _logAppException(AppException exception) {
    // * Optional to be replaced with a crash reporting tool. (Sentry, Crashlytics, etc.)
    if (kReleaseMode) {
      // TODO Watchout
    }

    // Warning level since it is recognized as a pre-defined Exception.
    _log.w('', error: exception);
  }
}

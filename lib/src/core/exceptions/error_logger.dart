import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '_exceptions.dart';

class ErrorLogger {
  final _log = Logger();

  void logError(Object error, StackTrace? stackTrace) {
    // * Optional to be replaced with a crash reporting tool. (Sentry, Crashlytics, etc.)
    if (kReleaseMode) {
      // TODO Watchout
    }

    // Fatal level since it isn't recognized as a defined AppException.
    _log.f('ERROR', error: error, stackTrace: stackTrace);
  }

  void logAppException(AppException exception) {
    // * Optional to be replaced with a crash reporting tool. (Sentry, Crashlytics, etc.)
    if (kReleaseMode) {
      // TODO Watchout
    }

    // Warning level since it is recognized as a defined AppException.
    _log.w('', error: exception);
  }
}

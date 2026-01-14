import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    level: kReleaseMode ? Level.nothing : Level.debug, // 🔥 KEY LINE
    printer: PrettyPrinter(
      methodCount: 2,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  // INFO
  static void info(String message) {
    if (!kReleaseMode) {
      _logger.i(message);
    }
  }

  // WARNING
  static void warn(String message) {
    if (!kReleaseMode) {
      _logger.w(message);
    }
  }

  // ERROR (optional: allow in release if you want)
  static void error(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    if (!kReleaseMode) {
      _logger.e(message, error: error, stackTrace: stackTrace);
    }
  }

  // DEBUG
  static void debug(String message) {
    if (!kReleaseMode) {
      _logger.d(message);
    }
  }

  // SUCCESS
  static void success(String message) {
    if (!kReleaseMode) {
      _logger.i("✅ SUCCESS: $message");
    }
  }
}

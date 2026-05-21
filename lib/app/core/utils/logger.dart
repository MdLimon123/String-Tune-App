import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';

import 'package:does_it_doom/app/core/config/environment.dart';

class AppLogger {
  AppLogger._();

  static void log(String message, {String tag = 'APP'}) {
    if (EnvironmentConfig.isDev || kDebugMode) {
      dev.log('[$tag] $message');
      print('[$tag] $message');
    }
  }

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    if (EnvironmentConfig.isDev || kDebugMode) {
      dev.log(
        '[ERROR] $message',
        error: error,
        stackTrace: stackTrace,
      );
      print('[ERROR] $message ${error != null ? ": $error" : ""}');
    }
  }

  static void network(String message) => log(message, tag: 'NETWORK');

  static void info(String message) => log(message, tag: 'INFO');
}

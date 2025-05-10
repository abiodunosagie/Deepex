import 'package:flutter/foundation.dart';

class AppLogger {
  static void log(String message, {String tag = 'APP'}) {
    if (kDebugMode) {
      print('[$tag] $message');
    }
  }

  static void error(String message, {String tag = 'ERROR'}) {
    if (kDebugMode) {
      print('[$tag] ❌ $message');
    }
  }
}

import 'package:flutter/foundation.dart';

class AppLogger {
  const AppLogger._();

  static void d(String tag, String message) {
    debugPrint('[$tag] $message');
  }
}

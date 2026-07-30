class Debuggable {
  /// Global flag to enable/disable debug-only behavior.
  static bool debugEnabled = false;

  /// Run [action] only when [debugEnabled] is true.
  static void run(void Function() action) {
    if (debugEnabled) {
      action();
    }
  }

  /// Log a message only in debug mode.
  static void log(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!debugEnabled) return;

    // You can replace this with your own logger later.
    // For now, just print.
    // Example formatting:
    final buffer = StringBuffer('[DEBUG] $message');
    if (error != null) buffer.write(' | error: $error');
    if (stackTrace != null) buffer.write('\n$stackTrace');
    // ignore: avoid_print
    print(buffer.toString());
  }
}
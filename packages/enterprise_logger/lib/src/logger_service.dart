/// Application logging contract for clean architecture.
///
/// Domain and presentation layers depend on this interface;
/// infrastructure provides the concrete implementation.
abstract class LoggerService {
  /// Logs a trace message.
  void t(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  });

  /// Logs a debug message.
  void d(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  });

  /// Logs an info message.
  void i(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  });

  /// Logs a warning message.
  void w(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  });

  /// Logs an error message.
  void e(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  });
}

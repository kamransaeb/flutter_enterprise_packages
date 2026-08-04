import 'package:enterprise_logger/src/logger_config.dart';
import 'package:enterprise_logger/src/logger_service.dart';
import 'package:logger/logger.dart' as log;

/// Concrete [LoggerService] backed by the `logger` package.
class LoggerServiceImpl implements LoggerService {
  /// Creates a logger configured from [LoggerConfig].
  LoggerServiceImpl({required LoggerConfig config})
      : _logger = log.Logger(
          filter: FlavorLogFilter(
            enableLogging: config.enableLogging,
            minLevel: _levelForFlavor(config.flavor),
          ),
          level: log.Level.trace,
          printer: log.PrettyPrinter(),
        );

  final log.Logger _logger;

  @override
  void t(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _logger.t(message, time: time, error: error, stackTrace: stackTrace);

  @override
  void d(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _logger.d(message, time: time, error: error, stackTrace: stackTrace);

  @override
  void i(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _logger.i(message, time: time, error: error, stackTrace: stackTrace);

  @override
  void w(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _logger.w(message, time: time, error: error, stackTrace: stackTrace);

  @override
  void e(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _logger.e(message, time: time, error: error, stackTrace: stackTrace);
}

/// Filters log events by enable flag and minimum [log.Level].
class FlavorLogFilter extends log.LogFilter {
  /// Creates a filter with [enableLogging] and [minLevel].
  FlavorLogFilter({
    required this.enableLogging,
    required this.minLevel,
  });

  /// Whether any logging is allowed.
  final bool enableLogging;

  /// Lowest level that will be emitted when logging is enabled.
  final log.Level minLevel;

  @override
  bool shouldLog(log.LogEvent event) {
    if (!enableLogging) return false;
    return event.level.index >= minLevel.index;
  }
}

// trace < debug < info < warning < error < fatal < off
log.Level _levelForFlavor(AppFlavor flavor) {
  return switch (flavor) {
    AppFlavor.dev => log.Level.trace,
    AppFlavor.staging => log.Level.info,
    AppFlavor.prod => log.Level.warning,
  };
}

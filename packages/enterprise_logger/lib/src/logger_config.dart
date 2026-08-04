import 'package:enterprise_logger/src/logger_service.dart';

/// Build / environment flavor used to tune log verbosity.
enum AppFlavor {
  /// Local development.
  dev,

  /// Pre-production.
  staging,

  /// Production.
  prod,
}

/// Configuration for [LoggerService] implementations.
class LoggerConfig {
  /// Creates a logger configuration.
  const LoggerConfig({
    required this.enableLogging,
    required this.flavor,
  });

  /// Whether logging is enabled at all.
  final bool enableLogging;

  /// Active app flavor.
  final AppFlavor flavor;
}

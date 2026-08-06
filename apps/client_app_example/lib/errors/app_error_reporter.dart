import 'package:enterprise_core/enterprise_core.dart';
import 'package:enterprise_logger/enterprise_logger.dart';

/// App-owned bridge from [ErrorHandler] to logging / crash reporting.
/// Later: Crashlytics / Sentry (app-owned)
class AppErrorReporter {
  /// Creates an [AppErrorReporter] that logs via [_logger].
  AppErrorReporter(this._logger);

  final LoggerService _logger;

  /// Callback suitable for [ErrorHandler.errorReporter].
  ErrorReporter get callback => _report;

  void _report(
    Object error, {
    StackTrace? stackTrace,
    String? reason,
    bool fatal = false,
    Map<String, dynamic>? extra,
  }) {
    _logger.e(
      reason ?? (fatal ? 'fatal error' : 'reported error'),
      error: error,
      stackTrace: stackTrace,
    );
    // later: Crashlytics / Sentry (app-owned)
    if (fatal) {
      // later: Crashlytics / Sentry (app-owned)
      // throw error;
    }
  }
}

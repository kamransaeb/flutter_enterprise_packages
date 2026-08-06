import 'package:client_app_example/errors/app_error_reporter.dart';
import 'package:enterprise_core/enterprise_core.dart';
import 'package:enterprise_logger/enterprise_logger.dart';
import 'package:injectable/injectable.dart';

/// Core module for dependency injection.
@module
abstract class CoreModule {
  /// Creates an [AppErrorReporter] that logs via [LoggerService].
  @singleton
  AppErrorReporter appErrorReporter(LoggerService logger) =>
      AppErrorReporter(logger);

  /// Creates an [ErrorHandler] that logs via [LoggerService] and reports via [AppErrorReporter].
  @singleton
  ErrorHandler errorHandler(
    LoggerService logger,
    AppErrorReporter appErrorReporter,
  ) => ErrorHandler(
    logger,
    errorReporter: appErrorReporter.callback,
  );
}

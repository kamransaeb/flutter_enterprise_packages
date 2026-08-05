import 'package:enterprise_core/enterprise_core.dart';
import 'package:enterprise_logger/enterprise_logger.dart';
import 'package:injectable/injectable.dart';

@module
abstract class CoreModule {
  @singleton
  ErrorHandler errorHandler(LoggerService logger) => ErrorHandler(
    logger,
    enableLogging: true,
    errorReporter: (error,{stackTrace, reason, fatal = false, extra}) {
      // later: Crashlytics / Sentry (app-owned)
      logger.e(
        reason ?? 'reported error',
        error: error,
        stackTrace: stackTrace,
        
      );
    },
  );
}
import 'package:enterprise_logger/enterprise_logger.dart';
import 'package:injectable/injectable.dart';

// @module annotation is used to define a module that will be used to inject the dependencies.
// This is useful when you want to inject a dependency that is not owned by you.
@module
abstract class LoggerModule {
  @singleton
  LoggerConfig loggerConfig() =>
      const LoggerConfig(flavor: AppFlavor.dev, enableLogging: true);

  @singleton
  LoggerService loggerService(LoggerConfig config) =>
      LoggerServiceImpl(config: config);
}

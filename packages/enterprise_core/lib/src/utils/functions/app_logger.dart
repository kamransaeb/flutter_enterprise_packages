// import 'package:flutter_enterprise_boilerplate/app/app_config.dart';
// import 'package:logger/logger.dart';

// /// App logger (package:logger). Call [LoggerService.initialize] from bootstrap.
// /// Singleton: only one instance is created; re-initialization is a no-op.
// class LoggerService {
//   static Logger? _instance;
//   static bool _initialized = false;

//   /// The shared logger instance. Throws if [initialize] has not been called.
//   static Logger get logger {
//     if (!_initialized || _instance == null) {
//       throw StateError(
//         'LoggerService not initialized. Call LoggerService.initialize(appConfig) from bootstrap.',
//       );
//     }
//     return _instance!;
//   }

//   /// Initialize the logger once. Subsequent calls are ignored (singleton guard).
//   static void initialize({required AppConfig appConfig}) {
//     if (_initialized) return;

//     _instance = Logger(
//       filter: FlavorLogFilter(
//         enableLogging: appConfig.enableLogging,
//         minLevel: _levelForFlavor(appConfig.flavor),
//       ),
//       level: Level.trace,
//       printer: PrettyPrinter(),
//     );
//     _initialized = true;
//   }

//   /// Whether the logger has been initialized (e.g. for tests).
//   static bool get isInitialized => _initialized;
// }

// class FlavorLogFilter extends LogFilter {
//   FlavorLogFilter({
//     required this.enableLogging,
//     required this.minLevel,
//   });

//   final bool enableLogging;
//   final Level minLevel;

//   @override
//   bool shouldLog(LogEvent event) {
//     if (!enableLogging) return false;
//     return event.level.index >= minLevel.index;
//   }
// }

// Level _levelForFlavor(Flavor flavor) {
//   return switch (flavor) {
//     Flavor.development => Level.trace,
//     Flavor.staging => Level.info,
//     Flavor.production => Level.warning,
//   };
// }

// /// Top-level getter so call sites can use [logger] instead of [LoggerService.logger].
// Logger get logger => LoggerService.logger;
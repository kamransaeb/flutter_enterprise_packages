import 'package:enterprise_logger/enterprise_logger.dart';
import 'package:enterprise_storage/enterprise_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  AppStorage._({
    required this.logger,
    required this.prefs,
    required this.secure,
    required this.hive,
  });

  final LoggerService logger;
  final SharedPrefsStorage prefs;
  final SecureStorage secure;
  final HiveStorage hive;
  
  static Future<AppStorage> create() async {
    final logger = LoggerServiceImpl(
       config: LoggerConfig( flavor: AppFlavor.dev, enableLogging: true),
    );

    final sharedPreferences = await SharedPreferences.getInstance(); 
    final prefs = SharedPrefsStorage(
      logger: logger,
      prefs: sharedPreferences,
    );

    final secure = SecureStorage(
      logger: logger,
  }
}
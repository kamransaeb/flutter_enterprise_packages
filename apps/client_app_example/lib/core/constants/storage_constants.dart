/// App-owned storage keys and Hive box names.
class StorageConstants {
  StorageConstants._();

  // ---------------------------------------------------------------------------
  // Hive boxes (must match StorageModule / HiveStorage.defaultBoxes)
  // ---------------------------------------------------------------------------

  /// Hive box for app settings.
  static const String settingsBox = 'settings_box';

  /// Hive box for temporary/cache data.
  static const String cacheBox = 'cache_box';

  /// Hive box for user profile data.
  static const String userBox = 'user_box';

  // ---------------------------------------------------------------------------
  // Settings / prefs
  // ---------------------------------------------------------------------------

  /// Key for the persisted theme mode.
  static const String themeMode = 'theme_mode';

  /// Key for the persisted dynamic color.
  static const String dynamicColor = 'dynamic_color';

  /// Key for the persisted font size scale.
  static const String fontSizeScale = 'font_size_scale';

  /// Key for the persisted high contrast.
  static const String highContrast = 'high_contrast';

  /// Key for the persisted locale.
  static const String localeKey = 'locale_key';

  /// Key for the language code.
  static const String languageCodeKey = 'language_code_key';

  /// Key for the country code.
  static const String countryCodeKey = 'country_code_key';

  /// Key indicating whether this is the first app launch.
  static const String isFirstLaunch = 'is_first_launch';

  /// Key for dark mode preference.
  static const String isDarkMode = 'is_dark_mode';
  
  /// Key for the selected UI language.
  static const String selectedLanguage = 'selected_language';

  /// Key for notification enabled preference.
  static const String notificationEnabled = 'notification_enabled';

  // ---------------------------------------------------------------------------
  // Demo (storage sample)
  // ---------------------------------------------------------------------------

  /// Demo counter key for storage samples.
  static const String demoCounter = 'demo_counter';

  /// Key for the last demo counter value.
  static const String lastCounter = 'last_counter';

  // ---------------------------------------------------------------------------
  // Auth / session (when you add auth)
  // ---------------------------------------------------------------------------

  /// Key for the persisted user model.
  static const String userKey = 'user_key';

  /// Key for the access token.
  static const String accessToken = 'access_token';

  /// Key for the refresh token.
  static const String refreshToken = 'refresh_token';

  /// Key for access token expiry.
  static const String tokenExpiresAt = 'token_expires_at';

  /// Key for the tokens bundle.
  static const String tokensKey = 'tokens_key';

  /// Key indicating an active session.
  static const String sessionActive = 'session_active';

  /// Key for remember-me preference.
  static const String rememberMe = 'remember_me';

  /// Key for biometric auth enabled preference.
  static const String biometricEnabled = 'biometric_enabled';

  /// Key for the device identifier.
  static const String deviceId = 'device_id';

  /// Default cache TTL.
  static const Duration defaultTtl = Duration(hours: 24);
}

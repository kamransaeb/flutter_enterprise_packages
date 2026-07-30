class StorageConstants {

     
  static const String localeKey = 'locale_key';
  static const String languageCodeKey = 'language_code_key';
  static const String countryCodeKey = 'country_code_key';

  static const String authBox = 'auth_box';
  static const String userBox = 'user_box';
  static const String settingsBox = 'settings_box';
  static const String cacheBox = 'cache_box';
  
  // static const String productsBoxCategoriesKey = 'products_categories_key';
  static const String productsBox = 'products_box';
  // static const String productsBoxRecentlyViewedKey = 'products_recently_viewed_key';
  // static const String productsBoxWishlistKey = 'products_wishlist_key';
  static const String productsBoxProductPrefix = 'product:';
  static const String productsBoxReviewsPrefix = 'reviews:';
  static const String productsBoxProductsPrefix = 'products:';
  static const String productsBoxPagePrefix = 'page:';
  static const String productsBoxWishlistPrefix = 'wishlist:';
  static const String productsBoxRelatedProductsPrefix = 'related_products:';
  static const String productsBoxFeaturedProductsPrefix = 'featured_products:';
  static const String productsBoxCategoriesPrefix = 'categories:';
  static const String productsBoxRecentlyViewedPrefix = 'recently_viewed:';

  static const String productsBoxLimitPrefix = 'limit:';
  static const String productsBoxFilterPrefix = 'filter:';


  static const int productsMaxRecentlyViewedItems = 10;
  static const int productsMaxWishlistItems = 20;
  static const Duration defaultTtl = Duration(hours: 24);



  static const String ordersBox = 'orders_box';
  static const String notificationsBox = 'notifications_box';
  static const String apiCacheBox = 'api_cache_box';

  static const String userKey = 'user_key';

  static const String isFirstLaunch = 'is_first_launch';
  static const String isDarkMode = 'is_dark_mode';
  static const String selectedLanguage = 'selected_language';
  static const String notificationEnabled = 'notification_enabled';

  static const String encryptionKey = 'my32lengthsupersecretnooneguess';
  static const String encryptionIv = '16byteslongrandomlygenerated';

  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String tokenExpiresAt = 'token_expires_at';
  static const String tokenIssuedAt = 'token_issued_at';
  static const String tokensKey = 'tokens_key';
  static const String tokenType = 'token_type';

  static const String sessionActive = 'session_active';

  static const String lastLoginEmail = 'last_login_email';
  static const String lastLoginDate = 'last_login_date';
  static const String biometricEnabled = 'biometric_enabled';
  static const String rememberMe = 'remember_me';
  static const String failedLoginAttempts = 'failed_login_attempts';
  static const String lockoutUntil = 'lockout_until';
  static const String sessionToken = 'session_token';
  static const String deviceId = 'device_id';
  static const String lastLoginDevice = 'last_login_device';
}
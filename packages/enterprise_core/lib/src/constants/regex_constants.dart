// lib/core/constants/regex_constants.dart

/// Centralized repository for all regex patterns used throughout the application
class RegexConstants {
  const RegexConstants._();

  // ============================================================
  // VALIDATION PATTERNS
  // ============================================================

  /// Email validation pattern
  /// Supports standard email formats: name@domain.com
  static final RegExp email = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Password validation pattern - Strong password
  /// Requires at least 8 characters, one uppercase, one lowercase, one number, one special character
  static final RegExp passwordStrong = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );

  /// Password validation pattern - Medium strength
  /// Requires at least 6 characters, one uppercase, one lowercase, one number
  static final RegExp passwordMedium = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{6,}$',
  );

  /// Password validation pattern - Basic
  /// Requires at least 6 characters
  static final RegExp passwordBasic = RegExp(
    r'^.{6,}$',
  );

  /// Phone number validation - International format
  /// Supports: +1234567890, 1234567890, (123) 456-7890
  static final RegExp phoneInternational = RegExp(
    r'^[\+]?[(]?[0-9]{1,4}[)]?[-\s\.]?[(]?[0-9]{1,4}[)]?[-\s\.]?[0-9]{1,5}[-\s\.]?[0-9]{1,5}$',
  );

  /// Phone number validation - US/Canada format
  static final RegExp phoneUS = RegExp(
    r'^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$',
  );

  /// Username validation
  /// Allows letters, numbers, underscores, dots (3-20 characters)
  static final RegExp username = RegExp(
    r'^[a-zA-Z0-9._]{3,20}$',
  );

  /// Name validation (Full name, first name, last name)
  /// Allows letters, spaces, hyphens, apostrophes (2-50 characters)
  static final RegExp name = RegExp(
    r"^[a-zA-ZÀ-ÿ\s\-']{2,50}$",
  );

  // ============================================================
  // FORMATTING PATTERNS
  // ============================================================

  /// URL validation pattern
  static final RegExp url = RegExp(
    r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
  );

  /// IP Address validation (IPv4)
  static final RegExp ipv4 = RegExp(
    r'^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
  );

  /// Hexadecimal color code validation
  /// Supports: #RGB, #RGBA, #RRGGBB, #RRGGBBAA
  static final RegExp hexColor = RegExp(
    r'^#?([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3}|[A-Fa-f0-9]{8}|[A-Fa-f0-9]{4})$',
  );

  /// Credit card number validation (Luhn algorithm not included)
  static final RegExp creditCard = RegExp(
    r'^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|3[47][0-9]{13}|6(?:011|5[0-9]{2})[0-9]{12})$',
  );

  /// CVV/CVC validation (3-4 digits)
  static final RegExp cvv = RegExp(r'^[0-9]{3,4}$');

  /// ZIP/Postal code validation (US format)
  static final RegExp zipCodeUS = RegExp(r'^\d{5}(-\d{4})?$');

  /// Postal code validation (International - basic)
  static final RegExp postalCodeInternational = RegExp(
    r'^[A-Za-z0-9\s\-]{3,10}$',
  );

  // ============================================================
  // JSON PATTERNS
  // ============================================================

  /// Pattern to find and remove trailing commas in JSON objects
  static final RegExp trailingCommaPattern = RegExp(r',(\s*[}\]])');

  /// Pattern to find and remove trailing commas in JSON arrays
  static final RegExp trailingCommaArrayPattern = RegExp(r',(\s*\])');

  /// Pattern to find unquoted JSON keys
  static final RegExp unquotedKeyPattern = RegExp(r'([\{,]\s*)([a-zA-Z0-9_]+)(\s*:)');

  /// Pattern to find single quotes in JSON (should be replaced with double quotes)
  static final RegExp singleQuotesPattern = RegExp(r"'([^'\\]*(?:\\.[^'\\]*)*)'");

  /// Pattern to find and remove null bytes from JSON string
  static final RegExp nullBytePattern = RegExp(r'\x00');

  // ============================================================
  // TEXT PATTERNS
  // ============================================================

  /// Alphanumeric pattern (letters and numbers only)
  static final RegExp alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');

  /// Alphabetic pattern (letters only)
  static final RegExp alphabetic = RegExp(r'^[a-zA-Z\s]+$');

  /// Numeric pattern (numbers only)
  static final RegExp numeric = RegExp(r'^\d+$');

  /// Decimal number pattern
  static final RegExp decimal = RegExp(r'^\d+(\.\d{1,2})?$');

  /// Whitespace pattern
  static final RegExp whitespace = RegExp(r'\s+');

  /// HTML tag pattern
  static final RegExp htmlTags = RegExp(r'<[^>]*>');

  /// Email mention pattern (for extracting @mentions)
  static final RegExp emailMention = RegExp(r'@([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})');

  /// Hashtag pattern (for extracting #hashtags)
  static final RegExp hashtag = RegExp(r'#([A-Za-z0-9_]+)');

  /// Mention pattern (for extracting @mentions)
  static final RegExp mention = RegExp(r'@([A-Za-z0-9_]+)');

  // ============================================================
  // DATE AND TIME PATTERNS
  // ============================================================

  /// Date pattern (YYYY-MM-DD)
  static final RegExp dateYYYYMMDD = RegExp(r'^\d{4}-\d{2}-\d{2}$');

  /// Date pattern (DD/MM/YYYY)
  static final RegExp dateDDMMYYYY = RegExp(r'^\d{2}/\d{2}/\d{4}$');

  /// Date pattern (MM/DD/YYYY)
  static final RegExp dateMMDDYYYY = RegExp(r'^\d{2}/\d{2}/\d{4}$');

  /// Time pattern (HH:MM:SS)
  static final RegExp timeHHMMSS = RegExp(r'^([01]\d|2[0-3]):([0-5]\d):([0-5]\d)$');

  /// Time pattern (HH:MM)
  static final RegExp timeHHMM = RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$');

  /// DateTime pattern (ISO 8601)
  static final RegExp dateTimeISO8601 = RegExp(
    r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d{3})?(Z|([+-]\d{2}:\d{2}))?$',
  );

  // ============================================================
  // SECURITY PATTERNS
  // ============================================================

  /// JWT Token pattern
  static final RegExp jwtToken = RegExp(
    r'^[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+$',
  );

  /// UUID/GUID pattern (version 4)
  static final RegExp uuid = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
    caseSensitive: false,
  );

  /// API Key pattern (alphanumeric and dashes, 16-64 characters)
  static final RegExp apiKey = RegExp(r'^[A-Za-z0-9\-]{16,64}$');

  /// Base64 pattern
  static final RegExp base64 = RegExp(r'^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$');

  // ============================================================
  // FILE PATTERNS
  // ============================================================

  /// Image file extensions
  static final RegExp imageFile = RegExp(
    r'\.(jpg|jpeg|png|gif|bmp|webp|svg|ico)$',
    caseSensitive: false,
  );

  /// Video file extensions
  static final RegExp videoFile = RegExp(
    r'\.(mp4|avi|mov|wmv|flv|mkv|webm)$',
    caseSensitive: false,
  );

  /// Audio file extensions
  static final RegExp audioFile = RegExp(
    r'\.(mp3|wav|ogg|flac|aac|m4a)$',
    caseSensitive: false,
  );

  /// Document file extensions
  static final RegExp documentFile = RegExp(
    r'\.(pdf|doc|docx|xls|xlsx|ppt|pptx|txt|rtf)$',
    caseSensitive: false,
  );

  // ============================================================
  // HELPER METHODS
  // ============================================================

  /// Check if string matches email pattern
  static bool isValidEmail(String email) => email.hasMatch(RegexConstants.email);

  /// Check if string matches strong password pattern
  static bool isStrongPassword(String password) => password.hasMatch(RegexConstants.passwordStrong);

  /// Check if string matches medium password pattern
  static bool isMediumPassword(String password) => password.hasMatch(RegexConstants.passwordMedium);

  /// Check if string matches phone number pattern
  static bool isValidPhone(String phone) => phone.hasMatch(RegexConstants.phoneInternational);

  /// Check if string matches URL pattern
  static bool isValidUrl(String url) => url.hasMatch(RegexConstants.url);

  /// Check if string matches username pattern
  static bool isValidUsername(String username) => username.hasMatch(RegexConstants.username);

  /// Check if string matches name pattern
  static bool isValidName(String name) => name.hasMatch(RegexConstants.name);

  /// Check if string matches hex color pattern
  static bool isValidHexColor(String color) => color.hasMatch(RegexConstants.hexColor);

  /// Check if string matches JWT token pattern
  static bool isValidJwtToken(String token) => token.hasMatch(RegexConstants.jwtToken);

  /// Check if string matches UUID pattern
  static bool isValidUuid(String uuid) => uuid.hasMatch(RegexConstants.uuid);

  /// Extract all hashtags from text
  static List<String> extractHashtags(String text) {
    return hashtag.allMatches(text).map((match) => match.group(1)!).toList();
  }

  /// Extract all mentions from text
  static List<String> extractMentions(String text) {
    return mention.allMatches(text).map((match) => match.group(1)!).toList();
  }

  /// Extract all email addresses from text
  static List<String> extractEmails(String text) {
    return email.allMatches(text).map((match) => match.group(0)!).toList();
  }

  /// Remove all HTML tags from string
  static String removeHtmlTags(String html) {
    return html.replaceAll(htmlTags, '');
  }

  /// Check if string contains only alphanumeric characters
  static bool isAlphanumeric(String text) => text.hasMatch(alphanumeric);

  /// Check if string contains only alphabetic characters
  static bool isAlphabetic(String text) => text.hasMatch(alphabetic);

  /// Check if string contains only numeric characters
  static bool isNumeric(String text) => text.hasMatch(numeric);
}

/// Extension method for easier regex usage
extension RegexExtension on String {
  /// Check if string matches the given regex pattern
  bool hasMatch(RegExp regExp) => regExp.hasMatch(this);

  /// Check if string matches email pattern
  bool get isValidEmail => RegexConstants.isValidEmail(this);

  /// Check if string matches strong password pattern
  bool get isStrongPassword => RegexConstants.isStrongPassword(this);

  /// Check if string matches phone pattern
  bool get isValidPhone => RegexConstants.isValidPhone(this);

  /// Check if string matches URL pattern
  bool get isValidUrl => RegexConstants.isValidUrl(this);

  /// Check if string matches username pattern
  bool get isValidUsername => RegexConstants.isValidUsername(this);

  /// Check if string matches name pattern
  bool get isValidName => RegexConstants.isValidName(this);

  /// Extract all hashtags from string
  List<String> get hashtags => RegexConstants.extractHashtags(this);

  /// Extract all mentions from string
  List<String> get mentions => RegexConstants.extractMentions(this);

  /// Extract all emails from string
  List<String> get emails => RegexConstants.extractEmails(this);

  /// Remove HTML tags from string
  String get withoutHtmlTags => RegexConstants.removeHtmlTags(this);

  /// Check if string is alphanumeric
  bool get isAlphanumeric => RegexConstants.isAlphanumeric(this);

  /// Check if string is alphabetic
  bool get isAlphabetic => RegexConstants.isAlphabetic(this);

  /// Check if string is numeric
  bool get isNumeric => RegexConstants.isNumeric(this);
}
import 'package:intl/intl.dart';

/// Common string helpers for validation, formatting, parsing, and masking.
extension StringExtensions on String {
  /// Whether this string has length `0`.
  bool get isNullOrEmpty => isEmpty;

  /// Whether this string has length greater than `0`.
  bool get isNotNullOrEmpty => isNotEmpty;

  /// Whether this string is empty or only whitespace.
  bool get isBlank => trim().isEmpty;

  /// Whether this string contains non-whitespace characters.
  bool get isNotBlank => !isBlank;

  /// Whether the string matches a simple email pattern.
  bool get isValidEmail {
    const pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    final regex = RegExp(pattern);
    return regex.hasMatch(this);
  }

  /// Whether the string matches a basic phone number pattern.
  bool get isValidPhone {
    const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    final regex = RegExp(pattern);
    return regex.hasMatch(this);
  }

  /// Whether the string meets a strong-password policy.
  ///
  /// Requires at least 8 characters, upper/lowercase, a digit, and a symbol.
  bool get isValidPassword {
    if (length < 8) return false;
    if (!contains(RegExp('[A-Z]'))) return false;
    if (!contains(RegExp('[a-z]'))) return false;
    if (!contains(RegExp('[0-9]'))) return false;
    if (!contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
    return true;
  }

  /// Returns the string with only the first character uppercased.
  String get capitalizeFirst {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Capitalizes the first letter of each whitespace-separated word.
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalizeFirst).join(' ');
  }

  /// Collapses consecutive whitespace into a single space and trims ends.
  String get removeExtraSpaces => replaceAll(RegExp(r'\s+'), ' ').trim();

  /// Converts whitespace-separated words to title case.
  String get toTitleCase {
    if (isEmpty) return this;
    return split(' ').map((word) {
      if (word.isEmpty) return word;
      return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
    }).join(' ');
  }

  /// Converts whitespace-separated words to CamelCase.
  String get toCamelCase {
    if (isEmpty) return this;
    final words = split(' ').map((word) => word.capitalizeFirst);
    return words.join();
  }

  /// Converts spaces to underscores and lowercases the string.
  String get toSnakeCase {
    if (isEmpty) return this;
    return toLowerCase().replaceAll(' ', '_');
  }

  /// Converts spaces to hyphens and lowercases the string.
  String get toKebabCase {
    if (isEmpty) return this;
    return toLowerCase().replaceAll(' ', '-');
  }

  /// Parses this string as an [int], or returns `null` if parsing fails.
  int? toIntOrNull() => int.tryParse(this);

  /// Parses this string as a [double], or returns `null` if parsing fails.
  double? toDoubleOrNull() => double.tryParse(this);

  /// Parses this string as a [num], or returns `null` if parsing fails.
  num? toNumOrNull() => num.tryParse(this);

  /// Parses this string as a [DateTime], or returns `null` if parsing fails.
  DateTime? toDateTimeOrNull() => DateTime.tryParse(this);

  /// Parses this string as a [DateTime], throwing if parsing fails.
  DateTime toDateTime() => DateTime.parse(this);

  /// Truncates the string to [maxLength] and appends [suffix] when needed.
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$suffix';
  }

  /// Truncates to 50 characters with an ellipsis suffix.
  String get ellipsis => truncate(50);

  /// Percent-encodes this string for use in a URI component.
  String get encodeUrl => Uri.encodeComponent(this);

  /// Decodes a percent-encoded URI component.
  String get decodeUrl => Uri.decodeComponent(this);

  /// Whether [Uri.parse] accepts this string without throwing.
  bool get isUrl {
    try {
      Uri.parse(this);
      return true;
    } on FormatException {
      return false;
    }
  }

  /// Parses this string as a [Uri].
  Uri get toUri => Uri.parse(this);

  /// Formats a numeric string using [locale]'s decimal pattern.
  String formatNumber({String locale = 'en_US'}) {
    final formatter = NumberFormat.decimalPattern(locale);
    final number = toDoubleOrNull();
    if (number == null) return this;
    return formatter.format(number);
  }

  /// Formats a numeric string as currency for [locale].
  String formatCurrency({
    String locale = 'en_US',
    String symbol = r'$',
    int decimalDigits = 2,
  }) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: decimalDigits,
    );
    final number = toDoubleOrNull();
    if (number == null) return this;
    return formatter.format(number);
  }

  /// Parses a date with [inputFormat] and rewrites it with [outputFormat].
  String formatDate({
    String inputFormat = 'yyyy-MM-dd',
    String outputFormat = 'MMM dd, yyyy',
  }) {
    try {
      final inputFormatter = DateFormat(inputFormat);
      final outputFormatter = DateFormat(outputFormat);
      final date = inputFormatter.parse(this);
      return outputFormatter.format(date);
    } on FormatException {
      return this;
    }
  }

  /// Masks the local part of an email, keeping domain visible.
  String maskEmail() {
    if (!isValidEmail) return this;
    final parts = split('@');
    if (parts.length != 2) return this;

    final username = parts[0];
    final domain = parts[1];

    if (username.length <= 2) {
      return '${'*' * username.length}@$domain';
    }

    final maskedUsername =
        '${username[0]}${'*' * (username.length - 2)}'
        '${username[username.length - 1]}';
    return '$maskedUsername@$domain';
  }

  /// Masks all but the last four characters of a phone-like string.
  String maskPhone() {
    if (!isValidPhone) return this;
    if (length <= 4) return this;

    final visibleDigits = substring(length - 4);
    final maskedDigits = '*' * (length - 4);
    return '$maskedDigits$visibleDigits';
  }
}

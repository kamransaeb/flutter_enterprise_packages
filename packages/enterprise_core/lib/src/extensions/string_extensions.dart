import 'package:intl/intl.dart';

extension StringExtensions on String {
  // Validation
  bool get isNullOrEmpty => isEmpty;
  bool get isNotNullOrEmpty => !isEmpty;
  bool get isBlank => trim().isEmpty;
  bool get isNotBlank => !isBlank;
  
  bool get isValidEmail {
    const pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    final regex = RegExp(pattern);
    return regex.hasMatch(this);
  }
  
  bool get isValidPhone {
    const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    final regex = RegExp(pattern);
    return regex.hasMatch(this);
  }
  
  bool get isValidPassword {
    if (length < 8) return false;
    if (!contains(RegExp(r'[A-Z]'))) return false;
    if (!contains(RegExp(r'[a-z]'))) return false;
    if (!contains(RegExp(r'[0-9]'))) return false;
    if (!contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
    return true;
  }
  
  // Formatting
  String get capitalizeFirst {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
  
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalizeFirst).join(' ');
  }
  
  String get removeExtraSpaces => replaceAll(RegExp(r'\s+'), ' ').trim();
  
  String get toTitleCase {
    if (isEmpty) return this;
    return split(' ').map((word) {
      if (word.isEmpty) return word;
      return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
    }).join(' ');
  }
  
  String get toCamelCase {
    if (isEmpty) return this;
    final words = split(' ').map((word) => word.capitalizeFirst);
    return words.join();
  }
  
  String get toSnakeCase {
    if (isEmpty) return this;
    return toLowerCase().replaceAll(' ', '_');
  }
  
  String get toKebabCase {
    if (isEmpty) return this;
    return toLowerCase().replaceAll(' ', '-');
  }
  
  // Parsing
  int? toIntOrNull() => int.tryParse(this);
  double? toDoubleOrNull() => double.tryParse(this);
  num? toNumOrNull() => num.tryParse(this);
  DateTime? toDateTimeOrNull() => DateTime.tryParse(this);
  
  DateTime toDateTime() => DateTime.parse(this);
  
  // Truncation
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$suffix';
  }
  
  String get ellipsis => truncate(50);
  
  // URL handling
  String get encodeUrl => Uri.encodeComponent(this);
  String get decodeUrl => Uri.decodeComponent(this);
  
  bool get isUrl {
    try {
      Uri.parse(this);
      return true;
    } catch (_) {
      return false;
    }
  }
  
  Uri get toUri => Uri.parse(this);
  
  // Number formatting
  String formatNumber({String locale = 'en_US'}) {
    final formatter = NumberFormat.decimalPattern(locale);
    final number = toDoubleOrNull();
    if (number == null) return this;
    return formatter.format(number);
  }
  
  String formatCurrency({
    String locale = 'en_US',
    String symbol = '\$',
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
  
  // Date formatting
  String formatDate({
    String inputFormat = 'yyyy-MM-dd',
    String outputFormat = 'MMM dd, yyyy',
  }) {
    try {
      final inputFormatter = DateFormat(inputFormat);
      final outputFormatter = DateFormat(outputFormat);
      final date = inputFormatter.parse(this);
      return outputFormatter.format(date);
    } catch (_) {
      return this;
    }
  }
  
  // Masking
  String maskEmail() {
    if (!isValidEmail) return this;
    final parts = split('@');
    if (parts.length != 2) return this;
    
    final username = parts[0];
    final domain = parts[1];
    
    if (username.length <= 2) {
      return '${'*' * username.length}@$domain';
    }
    
    final maskedUsername = '${username[0]}${'*' * (username.length - 2)}${username[username.length - 1]}';
    return '$maskedUsername@$domain';
  }
  
  String maskPhone() {
    if (!isValidPhone) return this;
    if (length <= 4) return this;
    
    final visibleDigits = substring(length - 4);
    final maskedDigits = '*' * (length - 4);
    return '$maskedDigits$visibleDigits';
  }
}
import 'package:intl/intl.dart';

/// Usage:
/// DateFormatter.date(DateTime.now());                 // 2026-08-01
/// DateFormatter.mediumDate(DateTime.now(), locale: 'tr');
/// DateFormatter.toIsoUtc(DateTime.now());
/// DateFormatter.tryParse('01/08/2026', pattern: 'dd/MM/yyyy');
/// DateFormatter.relative(DateTime.now().subtract(Duration(minutes: 5)));


/// Locale-aware date/time formatting and parsing helpers.
class DateFormatter {
  DateFormatter._();

  static final Map<String, DateFormat> _formatters = {};

  static DateFormat _formatter(String pattern, {String? locale}) {
    final key = '$locale|$pattern';
    return _formatters.putIfAbsent(
      key,
      () => DateFormat(pattern, locale),
    );
  }

  // ---------------------------------------------------------------------------
  // Format
  // ---------------------------------------------------------------------------

  /// Generic pattern format, e.g. `yyyy-MM-dd HH:mm`.
  static String format(
    DateTime date, {
    String pattern = 'yyyy-MM-dd',
    String? locale,
  }) {
    return _formatter(pattern, locale: locale).format(date.toLocal());
  }

  /// Formats as `yyyy-MM-dd`.
  static String date(DateTime date, {String? locale}) =>
      format(date, locale: locale);

  /// Formats as `yyyy-MM-dd HH:mm:ss`.
  static String dateTime(DateTime date, {String? locale}) =>
      format(date, pattern: 'yyyy-MM-dd HH:mm:ss', locale: locale);

  /// Formats as `HH:mm`.
  static String time(DateTime date, {String? locale}) =>
      format(date, pattern: 'HH:mm', locale: locale);

  /// Formats as `HH:mm:ss`.
  static String timeWithSeconds(DateTime date, {String? locale}) =>
      format(date, pattern: 'HH:mm:ss', locale: locale);

  /// Locale medium date, e.g. `Jan 3, 2026` (en_US).
  static String mediumDate(DateTime date, {String? locale}) {
    return DateFormat.yMMMd(locale).format(date.toLocal());
  }

  /// Locale long date, e.g. `January 3, 2026`.
  static String longDate(DateTime date, {String? locale}) {
    return DateFormat.yMMMMd(locale).format(date.toLocal());
  }

  /// Locale short date + time.
  static String shortDateTime(DateTime date, {String? locale}) {
    return DateFormat.yMd(locale).add_jm().format(date.toLocal());
  }

  /// ISO-8601 UTC string for APIs.
  static String toIsoUtc(DateTime date) => date.toUtc().toIso8601String();

  /// Relative label: Just now / 5 minutes ago / Yesterday / date.
  static String relative(
    DateTime date, {
    DateTime? now,
    String? locale,
  }) {
    final current = now ?? DateTime.now();
    final local = date.toLocal();
    final diff = current.difference(local);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) {
      final m = diff.inMinutes;
      return '$m minute${m == 1 ? '' : 's'} ago';
    }
    if (diff.inHours < 24 && _isSameDay(current, local)) {
      final h = diff.inHours;
      return '$h hour${h == 1 ? '' : 's'} ago';
    }
    if (_isSameDay(current.subtract(const Duration(days: 1)), local)) {
      return 'Yesterday';
    }
    if (diff.inDays < 7) {
      final d = diff.inDays;
      return '$d day${d == 1 ? '' : 's'} ago';
    }
    return mediumDate(local, locale: locale);
  }

  // ---------------------------------------------------------------------------
  // Parse
  // ---------------------------------------------------------------------------

  /// Parses [input] with [pattern], or returns `null` if parsing fails.
  static DateTime? tryParse(
    String input, {
    String pattern = 'yyyy-MM-dd',
    String? locale,
  }) {
    try {
      return _formatter(pattern, locale: locale).parseStrict(input);
    } on Object catch (_) {
      return null;
    }
  }

  /// Parses an ISO-8601 [input], or returns `null` if parsing fails.
  static DateTime? tryParseIso(String input) {
    try {
      return DateTime.parse(input);
    } on Object catch (_) {
      return null;
    }
  }

  /// Parses [input] with [pattern], or returns [fallback] / `DateTime.now()`.
  static DateTime parseOrFallback(
    String input, {
    String pattern = 'yyyy-MM-dd',
    String? locale,
    DateTime? fallback,
  }) {
    return tryParse(input, pattern: pattern, locale: locale) ??
        fallback ??
        DateTime.now();
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

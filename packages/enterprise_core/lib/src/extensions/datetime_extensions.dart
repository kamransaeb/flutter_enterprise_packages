import 'package:intl/intl.dart';

/// Formatting, comparison, and calendar helpers for [DateTime].
extension DateTimeExtensions on DateTime {
  /// Formats this date using the intl [pattern].
  String format(String pattern) {
    return DateFormat(pattern).format(this);
  }

  /// `yyyy-MM-dd` formatted date.
  String get yMd => format('yyyy-MM-dd');

  /// `yyyy-MM-dd HH:mm:ss` formatted date-time.
  String get yMdHms => format('yyyy-MM-dd HH:mm:ss');

  /// `HH:mm:ss` formatted time.
  String get hms => format('HH:mm:ss');

  /// `HH:mm` formatted time.
  String get hm => format('HH:mm');

  /// `MM-dd` formatted month and day.
  String get md => format('MM-dd');

  /// `MM/dd/yyyy` formatted date.
  String get mdy => format('MM/dd/yyyy');

  /// Relative time string such as `3 days ago` or `Just now`.
  String get humanReadable {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour'
          '${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute'
          '${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  /// Whether this date falls on today's calendar day.
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Whether this date falls on yesterday's calendar day.
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Whether this date falls on tomorrow's calendar day.
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Whether this instant is before now.
  bool get isPast => isBefore(DateTime.now());

  /// Whether this instant is after now.
  bool get isFuture => isAfter(DateTime.now());

  /// Whether this date is in the same week as today.
  bool get isCurrentWeek => _isSameWeek(this, DateTime.now());

  /// Whether this date is in the same month as today.
  bool get isCurrentMonth => _isSameMonth(this, DateTime.now());

  /// Whether this date is in the same year as today.
  bool get isCurrentYear => year == DateTime.now().year;

  /// Midnight at the start of this calendar day.
  DateTime get startOfDay => DateTime(year, month, day);

  /// Last millisecond of this calendar day.
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Start of the week containing this date (Monday).
  DateTime get startOfWeek {
    final weekday = this.weekday;
    return subtract(Duration(days: weekday - 1)).startOfDay;
  }

  /// End of the week containing this date (Sunday).
  DateTime get endOfWeek {
    final weekday = this.weekday;
    return add(Duration(days: 7 - weekday)).endOfDay;
  }

  /// First moment of this calendar month.
  DateTime get startOfMonth => DateTime(year, month);

  /// Last moment of this calendar month.
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);

  /// First moment of this calendar year.
  DateTime get startOfYear => DateTime(year);

  /// Last moment of this calendar year.
  DateTime get endOfYear => DateTime(year, 12, 31, 23, 59, 59, 999);

  /// Whole years elapsed from this date until today.
  int get age {
    final now = DateTime.now();
    var age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }

  /// Whether this date is a Monday.
  bool get isMonday => weekday == DateTime.monday;

  /// Whether this date is a Tuesday.
  bool get isTuesday => weekday == DateTime.tuesday;

  /// Whether this date is a Wednesday.
  bool get isWednesday => weekday == DateTime.wednesday;

  /// Whether this date is a Thursday.
  bool get isThursday => weekday == DateTime.thursday;

  /// Whether this date is a Friday.
  bool get isFriday => weekday == DateTime.friday;

  /// Whether this date is a Saturday.
  bool get isSaturday => weekday == DateTime.saturday;

  /// Whether this date is a Sunday.
  bool get isSunday => weekday == DateTime.sunday;

  /// Whether this date is Monday–Friday.
  bool get isWeekday =>
      weekday >= DateTime.monday && weekday <= DateTime.friday;

  /// Whether this date is Saturday or Sunday.
  bool get isWeekend =>
      weekday == DateTime.saturday || weekday == DateTime.sunday;

  /// Returns this date plus [days] days.
  DateTime addDays(int days) => add(Duration(days: days));

  /// Returns this date plus [hours] hours.
  DateTime addHours(int hours) => add(Duration(hours: hours));

  /// Returns this date plus [minutes] minutes.
  DateTime addMinutes(int minutes) => add(Duration(minutes: minutes));

  /// Returns this date plus [seconds] seconds.
  DateTime addSeconds(int seconds) => add(Duration(seconds: seconds));

  /// Returns this date minus [days] days.
  DateTime subtractDays(int days) => subtract(Duration(days: days));

  /// Returns this date minus [hours] hours.
  DateTime subtractHours(int hours) => subtract(Duration(hours: hours));

  /// Returns this date minus [minutes] minutes.
  DateTime subtractMinutes(int minutes) => subtract(Duration(minutes: minutes));

  /// Returns this date minus [seconds] seconds.
  DateTime subtractSeconds(int seconds) => subtract(Duration(seconds: seconds));

  /// Whether this instant is strictly between [start] and [end].
  bool isBetween(DateTime start, DateTime end) {
    return isAfter(start) && isBefore(end);
  }

  /// Whether this instant is between [start] and [end], inclusive.
  bool isBetweenInclusive(DateTime start, DateTime end) {
    return (isAfter(start) || isAtSameMomentAs(start)) &&
        (isBefore(end) || isAtSameMomentAs(end));
  }

  /// ISO-8601 string for this date-time.
  String get toIsoString => toIso8601String();

  /// Parses an ISO-8601 string, or returns `null` if invalid.
  static DateTime? fromIsoString(String isoString) =>
      DateTime.tryParse(isoString);

  /// Unix time in seconds.
  int get unixTimestamp => millisecondsSinceEpoch ~/ 1000;

  /// Builds a [DateTime] from a Unix timestamp in seconds.
  static DateTime fromUnixTimestamp(int timestamp) =>
      DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

  /// Adds [days] business days (skips weekends).
  DateTime addBusinessDays(int days) {
    var result = this;
    var remaining = days.abs();
    final step = days > 0 ? 1 : -1;

    while (remaining > 0) {
      result = result.addDays(step);
      if (result.isWeekday) {
        remaining--;
      }
    }

    return result;
  }

  /// Calendar quarter (1–4) for this date.
  int get quarter {
    if (month >= 1 && month <= 3) return 1;
    if (month >= 4 && month <= 6) return 2;
    if (month >= 7 && month <= 9) return 3;
    return 4;
  }

  /// First moment of the quarter containing this date.
  DateTime get startOfQuarter {
    final quarterMonth = ((quarter - 1) * 3) + 1;
    return DateTime(year, quarterMonth);
  }

  /// Last moment of the quarter containing this date.
  DateTime get endOfQuarter {
    final quarterMonth = quarter * 3;
    return DateTime(year, quarterMonth + 1, 0, 23, 59, 59, 999);
  }

  /// Duration from this instant until now.
  Duration get sinceNow => DateTime.now().difference(this);

  /// Duration from now until this instant.
  Duration get untilNow => difference(DateTime.now());

  bool _isSameWeek(DateTime a, DateTime b) {
    final startOfWeekA = a.startOfWeek;
    final startOfWeekB = b.startOfWeek;
    return startOfWeekA.year == startOfWeekB.year &&
        startOfWeekA.month == startOfWeekB.month &&
        startOfWeekA.day == startOfWeekB.day;
  }

  bool _isSameMonth(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month;
  }
}

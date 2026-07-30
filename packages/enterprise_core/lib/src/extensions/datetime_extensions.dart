import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  // Formatting
  String format(String pattern) {
    return DateFormat(pattern).format(this);
  }

  String get yMd => format('yyyy-MM-dd');
  String get yMdHms => format('yyyy-MM-dd HH:mm:ss');
  String get hms => format('HH:mm:ss');
  String get hm => format('HH:mm');
  String get md => format('MM-dd');
  String get mdy => format('MM/dd/yyyy');

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
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  // Comparison
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  bool get isPast => isBefore(DateTime.now());
  bool get isFuture => isAfter(DateTime.now());
  bool get isCurrentWeek => _isSameWeek(this, DateTime.now());
  bool get isCurrentMonth => _isSameMonth(this, DateTime.now());
  bool get isCurrentYear => year == DateTime.now().year;

  // Date manipulation
  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  DateTime get startOfWeek {
    final weekday = this.weekday;
    return subtract(Duration(days: weekday - 1)).startOfDay;
  }

  DateTime get endOfWeek {
    final weekday = this.weekday;
    return add(Duration(days: 7 - weekday)).endOfDay;
  }

  DateTime get startOfMonth => DateTime(year, month, 1);
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);

  DateTime get startOfYear => DateTime(year, 1, 1);
  DateTime get endOfYear => DateTime(year, 12, 31, 23, 59, 59, 999);

  // Age calculation
  int get age {
    final now = DateTime.now();
    var age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }

  // Weekday helpers
  bool get isMonday => weekday == DateTime.monday;
  bool get isTuesday => weekday == DateTime.tuesday;
  bool get isWednesday => weekday == DateTime.wednesday;
  bool get isThursday => weekday == DateTime.thursday;
  bool get isFriday => weekday == DateTime.friday;
  bool get isSaturday => weekday == DateTime.saturday;
  bool get isSunday => weekday == DateTime.sunday;

  bool get isWeekday => weekday >= DateTime.monday && weekday <= DateTime.friday;
  bool get isWeekend => weekday == DateTime.saturday || weekday == DateTime.sunday;

  // Adding time
  DateTime addDays(int days) => add(Duration(days: days));
  DateTime addHours(int hours) => add(Duration(hours: hours));
  DateTime addMinutes(int minutes) => add(Duration(minutes: minutes));
  DateTime addSeconds(int seconds) => add(Duration(seconds: seconds));

  DateTime subtractDays(int days) => subtract(Duration(days: days));
  DateTime subtractHours(int hours) => subtract(Duration(hours: hours));
  DateTime subtractMinutes(int minutes) => subtract(Duration(minutes: minutes));
  DateTime subtractSeconds(int seconds) => subtract(Duration(seconds: seconds));

  // Range checking
  bool isBetween(DateTime start, DateTime end) {
    return isAfter(start) && isBefore(end);
  }

  bool isBetweenInclusive(DateTime start, DateTime end) {
    return (isAfter(start) || isAtSameMomentAs(start)) &&
        (isBefore(end) || isAtSameMomentAs(end));
  }

  // Time zone
  DateTime toUtc() => toUtc();
  DateTime toLocal() => toLocal();

  // ISO format
  String get toIsoString => toIso8601String();
  static DateTime? fromIsoString(String isoString) =>
      DateTime.tryParse(isoString);

  // Unix timestamp
  int get unixTimestamp => millisecondsSinceEpoch ~/ 1000;
  static DateTime fromUnixTimestamp(int timestamp) =>
      DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

  // Business days
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

  // Quarter
  int get quarter {
    if (month >= 1 && month <= 3) return 1;
    if (month >= 4 && month <= 6) return 2;
    if (month >= 7 && month <= 9) return 3;
    return 4;
  }

  DateTime get startOfQuarter {
    final quarterMonth = ((quarter - 1) * 3) + 1;
    return DateTime(year, quarterMonth, 1);
  }

  DateTime get endOfQuarter {
    final quarterMonth = quarter * 3;
    return DateTime(year, quarterMonth + 1, 0, 23, 59, 59, 999);
  }

  // Duration since
  Duration get sinceNow => DateTime.now().difference(this);
  Duration get untilNow => difference(DateTime.now());

  // Private helper
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
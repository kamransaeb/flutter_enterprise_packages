import 'dart:math' as math;

import 'package:intl/intl.dart';

/// Convenience helpers on [num].
extension NumExtensions on num {
  /// Whether this number is inclusively between [min] and [max].
  bool isBetween(num min, num max) => this >= min && this <= max;

  /// Returns [min] when this value is below it; otherwise this value.
  num clampMin(num min) => this < min ? min : this;

  /// Returns [max] when this value is above it; otherwise this value.
  num clampMax(num max) => this > max ? max : this;

  /// Absolute value of this number.
  num get absolute => abs();

  /// This value as a [Duration] in milliseconds (rounded).
  Duration get milliseconds => Duration(milliseconds: round());

  /// This value as a [Duration] in seconds (rounded).
  Duration get seconds => Duration(seconds: round());

  /// This value as a [Duration] in minutes (rounded).
  Duration get minutes => Duration(minutes: round());

  /// Logical spacing/size token (app may map to text scale later).
  double get sp => toDouble();

  /// Logical width token.
  double get w => toDouble();

  /// Logical height token.
  double get h => toDouble();

  /// Formats this number as currency for [locale].
  String toCurrency({
    String locale = 'en_US',
    String? symbol,
    int decimalDigits = 2,
  }) {
    return NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: decimalDigits,
    ).format(this);
  }

  /// Formats this number as a percentage.
  ///
  /// Integers and doubles are treated as percent points (e.g. `25` → `25%`).
  String toPercent({int decimalDigits = 0}) {
    return NumberFormat.percentPattern().format(
      this is double || this is int ? this / 100 : this,
    );
  }

  /// Formats this number in a compact locale-aware form (e.g. `1.2K`).
  String toCompact({String locale = 'en_US'}) {
    return NumberFormat.compact(locale: locale).format(this);
  }

  /// Converts degrees to radians.
  double get degreesToRadians => this * math.pi / 180.0;

  /// Converts radians to degrees.
  double get radiansToDegrees => this * 180.0 / math.pi;
}

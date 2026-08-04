/// Shared duration tokens for UI, debounce, and short waits.
///
/// API timeouts belong in app config / network package, not here.
class DurationConstants {
  const DurationConstants._();

  /// Near-instant animation (~100ms).
  static const Duration instant = Duration(milliseconds: 100);

  /// Fast animation / transition (~150ms).
  static const Duration fast = Duration(milliseconds: 150);

  /// Default animation / transition (~300ms).
  static const Duration normal = Duration(milliseconds: 300);

  /// Slow animation / transition (~500ms).
  static const Duration slow = Duration(milliseconds: 500);

  /// Default debounce window for user input (~500ms).
  static const Duration debounce = Duration(milliseconds: 500);

  /// Default throttle window for repeated actions (~300ms).
  static const Duration throttle = Duration(milliseconds: 300);

  /// Default snackbar display time.
  static const Duration snackbar = Duration(seconds: 3);

  /// Short artificial delay (~300ms).
  static const Duration shortDelay = Duration(milliseconds: 300);

  /// Medium artificial delay (~1s).
  static const Duration mediumDelay = Duration(seconds: 1);

  /// Longer artificial delay (~2s).
  static const Duration longDelay = Duration(seconds: 2);

  /// Default cache time-to-live when none is specified.
  static const Duration defaultCacheTtl = Duration(hours: 24);
}

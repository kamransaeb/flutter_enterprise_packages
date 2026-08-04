import 'dart:async';
import 'dart:ui';

/// Schedules delayed callbacks and cancels prior ones per key.
mixin DebounceMixin {
  final Map<String, Timer> _debounceTimers = {};

  /// Runs [callback] after [duration], keyed by [key].
  ///
  /// When [cancelPrevious] is true, any pending timer for [key] is cancelled
  /// before scheduling the new one.
  void debounce(
    String key,
    Duration duration,
    VoidCallback callback, {
    bool cancelPrevious = true,
  }) {
    if (cancelPrevious) {
      _debounceTimers[key]?.cancel();
    }

    _debounceTimers[key] = Timer(duration, callback);
  }

  /// Cancels and removes the debounce timer for [key], if any.
  void cancelDebounce(String key) {
    _debounceTimers[key]?.cancel();
    _debounceTimers.remove(key);
  }

  /// Cancels all pending debounce timers.
  void cancelAllDebounces() {
    for (final timer in _debounceTimers.values) {
      timer.cancel();
    }
    _debounceTimers.clear();
  }

  /// Whether a debounce timer for [key] is currently active.
  bool isDebouncing(String key) {
    return _debounceTimers.containsKey(key) &&
        (_debounceTimers[key]?.isActive ?? false);
  }

  /// Remaining time for [key], if available.
  ///
  /// Always returns `null` because [Timer] does not expose remaining time.
  Duration? getRemainingTime(String key) {
    final timer = _debounceTimers[key];
    if (timer == null || !timer.isActive) return null;

    return null;
  }
}

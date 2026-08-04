
import 'dart:ui';

/// Limits how often a callback may run for a given key.
mixin ThrottleMixin {
  final Map<String, DateTime> _lastExecutions = {};

  /// Invokes [callback] at most once per [duration] for [key].
  void throttle(
    String key,
    Duration duration,
    VoidCallback callback,
  ) {
    final now = DateTime.now();
    final lastExecution = _lastExecutions[key];

    if (lastExecution == null || now.difference(lastExecution) >= duration) {
      _lastExecutions[key] = now;
      callback();
    }
  }

  /// Clears the last-execution timestamp for [key].
  void resetThrottle(String key) {
    _lastExecutions.remove(key);
  }

  /// Clears all throttle timestamps.
  void resetAllThrottles() {
    _lastExecutions.clear();
  }

  /// Whether [key] may run again given [duration] since the last execution.
  bool canExecute(String key, Duration duration) {
    final now = DateTime.now();
    final lastExecution = _lastExecutions[key];

    return lastExecution == null || now.difference(lastExecution) >= duration;
  }
}

/// Caps how many times a callback may run inside a sliding time window.
mixin RateLimitMixin {
  final Map<String, List<DateTime>> _executionHistory = {};
  final Map<String, int> _maxExecutions = {};
  final Map<String, Duration> _timeWindows = {};

  /// Configures [key] to allow at most [maxExecutions] per [timeWindow].
  void setRateLimit(
    String key,
    int maxExecutions,
    Duration timeWindow,
  ) {
    _maxExecutions[key] = maxExecutions;
    _timeWindows[key] = timeWindow;
  }

  /// Runs [callback] if [key] is under its rate limit; returns whether it ran.
  bool executeWithRateLimit(String key, VoidCallback callback) {
    _cleanupOldExecutions(key);

    final maxExecutions = _maxExecutions[key] ?? 1;
    final executions = _executionHistory[key] ?? [];

    if (executions.length >= maxExecutions) {
      return false;
    }

    _executionHistory.putIfAbsent(key, () => []).add(DateTime.now());
    callback();
    return true;
  }

  /// Whether [key] can execute without exceeding its rate limit.
  bool canExecute(String key) {
    _cleanupOldExecutions(key);

    final maxExecutions = _maxExecutions[key] ?? 1;
    final executions = _executionHistory[key] ?? [];

    return executions.length < maxExecutions;
  }

  /// Time until [key] may execute again, or [Duration.zero] if available now.
  Duration? getTimeUntilNextExecution(String key) {
    _cleanupOldExecutions(key);

    final timeWindow = _timeWindows[key];
    final executions = _executionHistory[key];

    if (timeWindow == null || executions == null || executions.isEmpty) {
      return Duration.zero;
    }

    final oldestExecution = executions.first;
    final nextAvailable = oldestExecution.add(timeWindow);
    final now = DateTime.now();

    if (nextAvailable.isAfter(now)) {
      return nextAvailable.difference(now);
    }

    return Duration.zero;
  }

  void _cleanupOldExecutions(String key) {
    final timeWindow = _timeWindows[key];
    final executions = _executionHistory[key];

    if (timeWindow == null || executions == null) return;

    final cutoff = DateTime.now().subtract(timeWindow);
    _executionHistory[key] =
        executions.where((execution) => execution.isAfter(cutoff)).toList();
  }

  /// Clears execution history for [key].
  void resetRateLimit(String key) {
    _executionHistory.remove(key);
  }

  /// Clears all rate-limit execution history.
  void resetAllRateLimits() {
    _executionHistory.clear();
  }
}

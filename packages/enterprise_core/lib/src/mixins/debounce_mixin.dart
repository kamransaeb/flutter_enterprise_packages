import 'dart:async';
import 'dart:ui';

mixin DebounceMixin {
  final Map<String, Timer> _debounceTimers = {};

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

  void cancelDebounce(String key) {
    _debounceTimers[key]?.cancel();
    _debounceTimers.remove(key);
  }

  void cancelAllDebounces() {
    for (final timer in _debounceTimers.values) {
      timer.cancel();
    }
    _debounceTimers.clear();
  }

  bool isDebouncing(String key) {
    return _debounceTimers.containsKey(key) &&
        (_debounceTimers[key]?.isActive ?? false);
  }

  Duration? getRemainingTime(String key) {
    final timer = _debounceTimers[key];
    if (timer == null || !timer.isActive) return null;
    
    // Timer doesn't expose remaining time directly
    // This is an approximation
    return null;
  }
}

mixin ThrottleMixin {
  final Map<String, bool> _throttleFlags = {};
  final Map<String, DateTime> _lastExecutions = {};

  void throttle(
    String key,
    Duration duration,
    VoidCallback callback,
  ) {
    final now = DateTime.now();
    final lastExecution = _lastExecutions[key];
    
    if (lastExecution == null ||
        now.difference(lastExecution) >= duration) {
      _lastExecutions[key] = now;
      callback();
    }
  }

  void resetThrottle(String key) {
    _lastExecutions.remove(key);
  }

  void resetAllThrottles() {
    _lastExecutions.clear();
  }

  bool canExecute(String key, Duration duration) {
    final now = DateTime.now();
    final lastExecution = _lastExecutions[key];
    
    return lastExecution == null ||
        now.difference(lastExecution) >= duration;
  }
}

mixin RateLimitMixin {
  final Map<String, List<DateTime>> _executionHistory = {};
  final Map<String, int> _maxExecutions = {};
  final Map<String, Duration> _timeWindows = {};

  void setRateLimit(
    String key,
    int maxExecutions,
    Duration timeWindow,
  ) {
    _maxExecutions[key] = maxExecutions;
    _timeWindows[key] = timeWindow;
  }

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

  bool canExecute(String key) {
    _cleanupOldExecutions(key);
    
    final maxExecutions = _maxExecutions[key] ?? 1;
    final executions = _executionHistory[key] ?? [];
    
    return executions.length < maxExecutions;
  }

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
    _executionHistory[key] = executions
        .where((execution) => execution.isAfter(cutoff))
        .toList();
  }

  void resetRateLimit(String key) {
    _executionHistory.remove(key);
  }

  void resetAllRateLimits() {
    _executionHistory.clear();
  }
}
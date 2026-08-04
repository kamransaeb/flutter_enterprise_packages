/// Allows at most [maxCalls] within [period].
class RateLimiter {
  /// Creates a [RateLimiter].
  RateLimiter({
    required this.period,
    required this.maxCalls,
  });

  /// Sliding window duration for counting calls.
  final Duration period;

  /// Maximum allowed calls within [period].
  final int maxCalls;
  final List<DateTime> _callTimestamps = [];

  /// Whether another call is currently allowed.
  bool get canCall {
    _cleanup();
    return _callTimestamps.length < maxCalls;
  }

  /// Records a call if under the limit. Returns whether it was allowed.
  bool tryAcquire() {
    if (!canCall) return false;
    _callTimestamps.add(DateTime.now());
    return true;
  }

  /// Time until the next call would be allowed, or [Duration.zero] if ready.
  Duration get timeUntilNextCall {
    _cleanup();

    if (_callTimestamps.length < maxCalls) {
      return Duration.zero;
    }

    final oldestCall = _callTimestamps.first;
    final nextAvailable = oldestCall.add(period);
    final now = DateTime.now();

    if (nextAvailable.isAfter(now)) {
      return nextAvailable.difference(now);
    }
    return Duration.zero;
  }

  void _cleanup() {
    final cutoff = DateTime.now().subtract(period);
    _callTimestamps.removeWhere((t) => t.isBefore(cutoff));
  }
}

import 'dart:async';

/// Runs an action immediately, then ignores calls until [delay] elapses.
class Throttler {
  /// Creates a [Throttler].
  Throttler({required this.delay});

  /// Minimum time between accepted calls.
  final Duration delay;
  Timer? _timer;
  bool _isExecuting = false;

  /// Invokes [callback] if not currently throttled.
  void call(void Function() callback) {
    if (_isExecuting) return;

    _isExecuting = true;
    callback();

    _timer?.cancel();
    _timer = Timer(delay, () {
      _isExecuting = false;
    });
  }

  /// Cancels the throttle window and allows the next call immediately.
  void cancel() {
    _timer?.cancel();
    _timer = null;
    _isExecuting = false;
  }

  /// Cancels the throttle window. Alias of [cancel].
  void dispose() => cancel();
}

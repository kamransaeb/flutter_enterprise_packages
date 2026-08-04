import 'dart:async';

/// Runs an action only after calls stop for [delay].
class Debouncer {
  /// Creates a [Debouncer].
  Debouncer({required this.delay});

  /// Delay after the last call before [call]'s callback runs.
  final Duration delay;
  Timer? _timer;

  /// Schedules [callback], canceling any previously scheduled run.
  void call(void Function() callback) {
    _timer?.cancel();
    _timer = Timer(delay, callback);
  }

  /// Cancels any pending callback.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Cancels any pending callback. Alias of [cancel].
  void dispose() => cancel();

  /// Whether a callback is currently scheduled.
  bool get isActive => _timer?.isActive ?? false;
}

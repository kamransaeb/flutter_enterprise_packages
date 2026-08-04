import 'dart:async';

/// Tracks [StreamSubscription]s and cancels them on dispose.
mixin DisposableMixin {
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  /// Registers [subscription] so it can be cancelled later.
  void addSubscription(StreamSubscription<dynamic> subscription) {
    _subscriptions.add(subscription);
  }

  /// Cancels and clears all registered subscriptions.
  void cancelSubscriptions() {
    for (final sub in _subscriptions) {
      unawaited(sub.cancel());
    }
    _subscriptions.clear();
  }
}

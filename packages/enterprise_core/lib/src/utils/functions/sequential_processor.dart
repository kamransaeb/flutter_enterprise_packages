import 'dart:async';
import 'dart:collection';

/// Runs async operations one at a time, with optional delay between them.
class SequentialProcessor {
  /// Creates a [SequentialProcessor].
  SequentialProcessor({required this.delayBetweenOperations});

  /// Delay after each operation before starting the next.
  final Duration delayBetweenOperations;
  bool _isProcessing = false;
  final Queue<Future<void> Function()> _queue = Queue();

  /// Enqueues [operation] and starts processing if idle.
  Future<void> add(Future<void> Function() operation) async {
    _queue.add(operation);
    await _processNext();
  }

  Future<void> _processNext() async {
    if (_isProcessing || _queue.isEmpty) return;

    _isProcessing = true;
    try {
      final operation = _queue.removeFirst();
      await operation();
      if (delayBetweenOperations > Duration.zero) {
        await Future<void>.delayed(delayBetweenOperations);
      }
    } finally {
      _isProcessing = false;
      unawaited(_processNext());
    }
  }

  /// Clears all pending operations.
  void clear() => _queue.clear();

  /// Number of operations waiting to run.
  int get pendingOperations => _queue.length;
}

import 'dart:async';

/// Buffers items and flushes by size or time.
class BatchProcessor<T> {
  /// Creates a [BatchProcessor].
  BatchProcessor({
    required this.batchDuration,
    required this.maxBatchSize,
    required this.processor,
  });

  /// Maximum time to wait before flushing a non-empty batch.
  final Duration batchDuration;

  /// Maximum number of items before an immediate flush.
  final int maxBatchSize;

  /// Called with the current batch when flushed.
  final void Function(List<T>) processor;

  final List<T> _buffer = [];
  Timer? _batchTimer;

  /// Adds [item] to the buffer and may trigger a flush.
  void add(T item) {
    _buffer.add(item);

    if (_buffer.length >= maxBatchSize) {
      _processBatch();
    } else {
      _batchTimer ??= Timer(batchDuration, _processBatch);
    }
  }

  /// Flushes any buffered items immediately.
  void flush() => _processBatch();

  /// Cancels the timer and clears the buffer without processing.
  void dispose() {
    _batchTimer?.cancel();
    _buffer.clear();
  }

  void _processBatch() {
    if (_buffer.isEmpty) return;

    final batch = List<T>.from(_buffer);
    _buffer.clear();
    _batchTimer?.cancel();
    _batchTimer = null;
    processor(batch);
  }
}

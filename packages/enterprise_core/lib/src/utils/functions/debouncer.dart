import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({required this.delay});

  void call(void Function() callback) {
    _timer?.cancel();
    _timer = Timer(delay, callback);
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  bool get isActive => _timer?.isActive ?? false;
}

class Throttler {
  final Duration delay;
  Timer? _timer;
  bool _isExecuting = false;

  Throttler({required this.delay});

  void call(void Function() callback) {
    if (_isExecuting) return;
    
    _isExecuting = true;
    callback();
    
    _timer?.cancel();
    _timer = Timer(delay, () {
      _isExecuting = false;
    });
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
    _isExecuting = false;
  }
}

class RateLimiter {
  final Duration period;
  final int maxCalls;
  final List<DateTime> _callTimestamps = [];

  RateLimiter({
    required this.period,
    required this.maxCalls,
  });

  bool get canCall {
    _cleanup();
    return _callTimestamps.length < maxCalls;
  }

  bool call() {
    if (!canCall) {
      return false;
    }
    
    _callTimestamps.add(DateTime.now());
    return true;
  }

  void _cleanup() {
    final cutoff = DateTime.now().subtract(period);
    _callTimestamps.removeWhere((timestamp) => timestamp.isBefore(cutoff));
  }

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
}

class DebouncedTextController extends TextEditingController {
  final Duration delay;
  final ValueChanged<String> onDebouncedTextChanged;
  
  Timer? _debounceTimer;

  DebouncedTextController({
    required this.delay,
    required this.onDebouncedTextChanged,
    String? text,
  }) : super(text: text) {
    addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }
    
    _debounceTimer = Timer(delay, () {
      onDebouncedTextChanged(text);
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

class BatchProcessor<T> {
  final Duration batchDuration;
  final int maxBatchSize;
  final void Function(List<T>) processor;
  
  List<T> _buffer = [];
  Timer? _batchTimer;

  BatchProcessor({
    required this.batchDuration,
    required this.maxBatchSize,
    required this.processor,
  });

  void add(T item) {
    _buffer.add(item);
    
    if (_buffer.length >= maxBatchSize) {
      _processBatch();
    } else if (_batchTimer == null) {
      _batchTimer = Timer(batchDuration, _processBatch);
    }
  }

  void _processBatch() {
    if (_buffer.isEmpty) return;
    
    final batch = List<T>.from(_buffer);
    _buffer.clear();
    
    _batchTimer?.cancel();
    _batchTimer = null;
    
    processor(batch);
  }

  void flush() {
    _processBatch();
  }

  void dispose() {
    _batchTimer?.cancel();
    _buffer.clear();
  }
}

class SequentialProcessor {
  final Duration delayBetweenOperations;
  bool _isProcessing = false;
  final Queue<Future<void> Function()> _queue = Queue();

  SequentialProcessor({required this.delayBetweenOperations});

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
        await Future.delayed(delayBetweenOperations);
      }
    } finally {
      _isProcessing = false;
      _processNext();
    }
  }

  void clear() {
    _queue.clear();
  }

  int get pendingOperations => _queue.length;
}
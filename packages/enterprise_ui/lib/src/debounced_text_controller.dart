import 'dart:async';

import 'package:flutter/widgets.dart';

/// [TextEditingController] that notifies after text stops changing.
class DebouncedTextController extends TextEditingController {
  /// Creates a new [DebouncedTextController].
  DebouncedTextController({
    required this.delay,
    required this.onDebouncedTextChanged,
    super.text,
  }) {
    addListener(_onTextChanged);
  }

  /// Delay before notifying.
  final Duration delay;
  /// Callback when text is debounced.
  final ValueChanged<String> onDebouncedTextChanged;
  /// Timer for debouncing.
  Timer? _debounceTimer;

  void _onTextChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(delay, () {
      onDebouncedTextChanged(text);
    });
  }

  @override
  void dispose() {
    removeListener(_onTextChanged);
    _debounceTimer?.cancel();
    super.dispose();
  }
}

import 'dart:async';

import 'package:flutter/widgets.dart';

/// [TextEditingController] that notifies after text stops changing.
class DebouncedTextController extends TextEditingController {
  DebouncedTextController({
    required this.delay,
    required this.onDebouncedTextChanged,
    super.text,
  }) {
    addListener(_onTextChanged);
  }

  final Duration delay;
  final ValueChanged<String> onDebouncedTextChanged;
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
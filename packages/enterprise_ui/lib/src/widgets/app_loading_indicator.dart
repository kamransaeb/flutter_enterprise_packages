import 'package:flutter/material.dart';

/// Size of [AppLoadingIndicator].
enum AppLoadingSize {
  /// Small loading indicator.
  small,
  /// Medium loading indicator.
  medium,
  /// Large loading indicator.
  large,
}

/// Circular or linear progress.
class AppLoadingIndicator extends StatelessWidget {
  /// Creates a new [AppLoadingIndicator].
  const AppLoadingIndicator({
    super.key,
    this.size = AppLoadingSize.medium,
    this.message,
    this.linear = false,
  });

  /// Visual size (circular only).
  final AppLoadingSize size;

  /// Optional message to display below the indicator.
  final String? message;

  /// Whether to use a linear progress indicator instead of a circular one.
  final bool linear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;

    final indicator = linear
        ? LinearProgressIndicator(color: color)
        : SizedBox(
            width: _dimension,
            height: _dimension,
            child: CircularProgressIndicator(strokeWidth: _stoke, color: color),
          );

    if (message == null) return indicator;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        indicator,
        const SizedBox(height: 16),
        Text(message!, style: theme.textTheme.bodyMedium),
      ],
    );
  }

  double get _dimension => switch (size) {
    AppLoadingSize.small => 20,
    AppLoadingSize.medium => 32,
    AppLoadingSize.large => 48,
  };

  double get _stoke => switch (size) {
    AppLoadingSize.small => 2,
    AppLoadingSize.medium => 3,
    AppLoadingSize.large => 4,
  };
}

import 'package:flutter/material.dart';

/// Visual style of [AppButton].
enum AppButtonVariant { 
  /// Filled button.
  filled,
  /// Tonal button.
  tonal,
  /// Outlined button.
  outlined,
  /// Text button.
  text,
  /// Danger button.
  danger,
}

/// Size of [AppButton].
enum AppButtonSize {
  /// Small button.
  small,
  /// Medium button.
  medium,
  /// Large button.
  large,
}

/// Shared action button. Label copy comes from the app.
class AppButton extends StatelessWidget {
  /// Creates a [AppButton].
  const AppButton({
    required this.label,
    super.key,
    this.onPressed,
    this.variant = AppButtonVariant.filled,
    this.size = AppButtonSize.medium,
    this.expanded = false,
    this.loading = false,
    this.icon,
  });

  /// Button text (app / l10n).
  final String label;

  /// Tap handler. Null or [loading] disables the button.
  final VoidCallback? onPressed;

  /// Visual variant.
  final AppButtonVariant variant;

  /// Padding / type scale.
  final AppButtonSize size;

  /// Stretch to parent width.
  final bool expanded;

  /// Shows a spinner and disables taps.
  final bool loading;

  /// Optional leading icon.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    final child = _child(context);
    final style = _style(Theme.of(context));

    final button = switch (variant) {
      AppButtonVariant.filled || AppButtonVariant.danger => FilledButton(
        onPressed: enabled ? onPressed : null,
        style: style,
        child: child,
      ),
      AppButtonVariant.tonal => FilledButton.tonal(
        onPressed: enabled ? onPressed : null,
        style: style,
        child: child,
      ),
      AppButtonVariant.outlined => OutlinedButton(
        onPressed: enabled ? onPressed : null,
        style: style,
        child: child,
      ),
      AppButtonVariant.text => TextButton(
        onPressed: enabled ? onPressed : null,
        style: style,
        child: child,
      ),
    };

    if (!expanded) return button;
    return SizedBox(width: double.infinity, child: button);
  }

  Widget _child(BuildContext context) {
    if (loading) {
      return const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    final labelWidget = Text(label);
    if (icon == null) return labelWidget;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [Icon(icon, size: 18), const SizedBox(width: 8), labelWidget],
    );
  }

  ButtonStyle _style(ThemeData theme) {
    final padding = switch (size) {
      AppButtonSize.small => const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      AppButtonSize.medium => const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      AppButtonSize.large => const EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 16,
      ),
    };
    
    var style = ButtonStyle(
      padding: WidgetStateProperty.all(padding),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    if (variant == AppButtonVariant.danger) {
      style = style.copyWith(
        backgroundColor: WidgetStatePropertyAll(theme.colorScheme.error),
        foregroundColor: WidgetStatePropertyAll(theme.colorScheme.onError),
      );
    }
    return style;
  }
}

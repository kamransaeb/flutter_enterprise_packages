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

  /// Icon-only button with no padding or splash.
  icon,

  /// Circular icon button with optional border.
  roundIcon,
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
    super.key,
    this.label = '',
    this.onPressed,
    this.variant = AppButtonVariant.filled,
    this.size = AppButtonSize.medium,
    this.expanded = false,
    this.icon,
    this.iconWidget,
    this.border = true,
    this.borderColor,
    this.boxColor,
    this.paddingSize = 8,
    this.borderWidth = 1.2,
    this.borderRadius = 12,
  });

  /// Button text (app / l10n). Unused for [AppButtonVariant.icon] /
  /// [AppButtonVariant.roundIcon].
  final String label;

  /// Tap handler
  final VoidCallback? onPressed;

  /// Visual variant.
  final AppButtonVariant variant;

  /// Padding / type scale.
  final AppButtonSize size;

  /// Stretch to parent width.
  final bool expanded;

  /// Optional leading [IconData], or the icon for icon variants when
  /// [iconWidget] is null.
  final IconData? icon;

  /// Icon widget for [AppButtonVariant.icon] / [AppButtonVariant.roundIcon].
  /// Takes precedence over [icon].
  final Widget? iconWidget;

  /// Whether [AppButtonVariant.roundIcon] draws a border.
  final bool border;

  /// Border color for [AppButtonVariant.roundIcon].
  final Color? borderColor;

  /// Background color for [AppButtonVariant.roundIcon].
  final Color? boxColor;

  /// Inner padding for [AppButtonVariant.roundIcon].
  final double paddingSize;

  /// Corner radius for non-circular button variants.
  final double borderRadius;

  /// Border stroke width for [AppButtonVariant.roundIcon].
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final theme = Theme.of(context);

    final button = switch (variant) {
      AppButtonVariant.filled || AppButtonVariant.danger => FilledButton(
        onPressed: enabled ? onPressed : null,
        style: _style(theme),
        child: _labelChild(),
      ),
      AppButtonVariant.tonal => FilledButton.tonal(
        onPressed: enabled ? onPressed : null,
        style: _style(theme),
        child: _labelChild(),
      ),
      AppButtonVariant.outlined => OutlinedButton(
        onPressed: enabled ? onPressed : null,
        style: _style(theme),
        child: _labelChild(),
      ),
      AppButtonVariant.text => TextButton(
        onPressed: enabled ? onPressed : null,
        style: _style(theme),
        child: _labelChild(),
      ),
      AppButtonVariant.icon => IconButton(
        onPressed: enabled ? onPressed : null,
        style: IconButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          overlayColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          surfaceTintColor: Colors.transparent,
        ),
        icon: _resolvedIcon(),
      ),
      AppButtonVariant.roundIcon => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: enabled ? onPressed : null,
          child: Container(
            padding: EdgeInsets.all(paddingSize),
            decoration: BoxDecoration(
              border: Border.all(
                color: border
                    ? (borderColor ?? theme.colorScheme.onSurface)
                    : (boxColor ?? theme.colorScheme.surface),
                width: border ? borderWidth : 0,
              ),
              shape: BoxShape.circle,
              color: boxColor ?? theme.colorScheme.surface,
            ),
            child: _resolvedIcon(),
          ),
        ),
      ),
    };

    if (!expanded ||
        variant == AppButtonVariant.icon ||
        variant == AppButtonVariant.roundIcon) {
      return button;
    }
    return SizedBox(width: double.infinity, child: button);
  }

  Widget _resolvedIcon() {
    if (iconWidget != null) return iconWidget!;
    if (icon != null) return Icon(icon, size: 18);
    return const SizedBox.shrink();
  }

  Widget _labelChild() {
    final labelWidget = Text(label);
    if (icon == null && iconWidget == null) return labelWidget;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        iconWidget ?? Icon(icon, size: 18),
        const SizedBox(width: 8),
        labelWidget,
      ],
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
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
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

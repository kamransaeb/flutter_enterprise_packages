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
  large;

  /// Icon size for [AppButtonSize.small].
  static const double iconSizeSmall = 15;

  /// Icon size for [AppButtonSize.medium].
  static const double iconSizeMedium = 20;

  /// Icon size for [AppButtonSize.large].
  static const double iconSizeLarge = 25;

  /// Leading / icon-only glyph size for this button size.
  double get iconSize => switch (this) {
    AppButtonSize.small => iconSizeSmall,
    AppButtonSize.medium => iconSizeMedium,
    AppButtonSize.large => iconSizeLarge,
  };
}

/// Shared action button. Label copy comes from the app.
class AppButton extends StatelessWidget {
  /// Creates a [AppButton].
  const AppButton({
    super.key,
    this.label = '',
    this.labelStyle,
    this.onPressed,
    this.variant = AppButtonVariant.filled,
    this.size = AppButtonSize.medium,
    this.expanded = false,
    this.icon,
    this.iconWidget,
    this.border = true,
    this.borderColor,
    this.boxColor,
    this.padding,
    this.roundIconInnerPaddingSize = 8,
    this.borderWidth = 1.2,
    this.borderRadius = 12,
  });

  /// Button text (app / l10n). Unused for [AppButtonVariant.icon] /
  /// [AppButtonVariant.roundIcon].
  final String label;

  /// Button text style.
  final TextStyle? labelStyle;

  /// Tap handler
  final VoidCallback? onPressed;

  /// Visual variant.
  final AppButtonVariant variant;

  /// Padding / type scale.
  ///
  /// Used for default padding when [padding] is null.
  final AppButtonSize size;

  /// Stretch to parent width.
  final bool expanded;

  /// Optional leading [IconData], or the icon for icon variants when
  /// [iconWidget] is null.
  final IconData? icon;

  /// Icon widget for [AppButtonVariant.icon] / [AppButtonVariant.roundIcon].
  /// Takes precedence over [icon].
  final Widget? iconWidget;

  /// Whether a border is drawn when [borderColor] is set (and for
  /// [AppButtonVariant.roundIcon]).
  final bool border;

  /// Border color override for all variants.
  ///
  /// For Material variants this sets [ButtonStyle.side].
  /// For [AppButtonVariant.roundIcon] it paints the circle stroke.
  final Color? borderColor;

  /// Background / fill color override for all variants.
  ///
  /// For Material variants this sets [ButtonStyle.backgroundColor].
  /// For [AppButtonVariant.roundIcon] it paints the circle fill.
  final Color? boxColor;

  /// Optional padding override for Material button variants.
  ///
  /// When null, padding comes from [size].
  /// When [EdgeInsets.zero], also shrinks [ButtonStyle.minimumSize] and
  /// [ButtonStyle.tapTargetSize] so the label sits flush next to adjacent text.
  final EdgeInsetsGeometry? padding;

  /// Inner padding for [AppButtonVariant.roundIcon].
  final double roundIconInnerPaddingSize;

  /// Corner radius for non-circular button variants.
  final double borderRadius;

  /// Border stroke width when [borderColor] is applied.
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
          padding: padding ?? EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          overlayColor: Colors.transparent,
          backgroundColor: boxColor ?? Colors.transparent,
          side: _resolvedSide(),
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
            padding: EdgeInsets.all(roundIconInnerPaddingSize),
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
    if (icon != null) return Icon(icon, size: size.iconSize);
    return const SizedBox.shrink();
  }

  BorderSide? _resolvedSide() {
    if (!border || borderColor == null) return null;
    return BorderSide(color: borderColor!, width: borderWidth);
  }

  Widget _labelChild() {
    // No default style: inherit Material's textStyle + foregroundColor so
    // ThemeData.*ButtonTheme (e.g. filledButtonTheme) can control typography
    // and enabled/disabled colors. Callers that pass [labelStyle] opt out.
    final labelWidget = Text(label, style: labelStyle);
    if (icon == null && iconWidget == null) return labelWidget;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        iconWidget ?? Icon(icon, size: size.iconSize),
        if (padding == null)
          const SizedBox(width: 8)
        else
          SizedBox(width: padding!.horizontal),
        labelWidget,
      ],
    );
  }

  ButtonStyle _style(ThemeData theme) {
    final resolvedPadding =
        padding ??
        switch (size) {
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

    final isCompact = padding == EdgeInsets.zero;

    var style = ButtonStyle(
      // Only override textStyle when the caller passed [labelStyle]; otherwise
      // leave null so filled/outlined/text ButtonTheme wins.
      textStyle: labelStyle != null ? WidgetStatePropertyAll(labelStyle) : null,
      padding: WidgetStateProperty.all(resolvedPadding),
      // Zero padding alone is not enough — Material still keeps min size / tap
      // target, which leaves a gap next to adjacent Text.
      minimumSize: isCompact ? const WidgetStatePropertyAll(Size.zero) : null,
      tapTargetSize: isCompact ? MaterialTapTargetSize.shrinkWrap : null,
      visualDensity: isCompact ? VisualDensity.compact : null,
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );

    if (variant == AppButtonVariant.danger) {
      style = style.copyWith(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          // null when disabled → theme / M3 disabled background
          if (states.contains(WidgetState.disabled)) return null;
          return boxColor ?? theme.colorScheme.error;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return null;
          return theme.colorScheme.onError;
        }),
      );
    } else if (boxColor != null) {
      style = style.copyWith(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return null;
          return boxColor;
        }),
      );
    }

    final side = _resolvedSide();
    if (side != null) {
      style = style.copyWith(side: WidgetStatePropertyAll(side));
    }
    return style;
  }
}

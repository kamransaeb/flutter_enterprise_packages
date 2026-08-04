import 'package:flutter/material.dart';

/// Convenience wrappers around common layout / interaction widgets.
extension WidgetExtensions on Widget {
  /// Wraps this widget with uniform [Padding] of [value].
  Widget paddingAll(double value) =>
      Padding(padding: EdgeInsets.all(value), child: this);

  /// Wraps this widget with symmetric horizontal/vertical [Padding].
  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) =>
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal,
          vertical: vertical,
        ),
        child: this,
      );

  /// Wraps this widget with [Padding] on individual sides.
  Widget paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) =>
      Padding(
        padding: EdgeInsets.only(
          left: left,
          top: top,
          right: right,
          bottom: bottom,
        ),
        child: this,
      );

  /// Wraps this widget in a [Container] with uniform margin.
  ///
  /// Prefer [paddingAll] when possible.
  Widget marginAll(double value) =>
      Container(margin: EdgeInsets.all(value), child: this);

  /// Wraps this widget in a [Container] with symmetric margin.
  Widget marginSymmetric({double horizontal = 0, double vertical = 0}) =>
      Container(
        margin: EdgeInsets.symmetric(
          horizontal: horizontal,
          vertical: vertical,
        ),
        child: this,
      );

  /// Constrains this widget with a [SizedBox].
  Widget sized({double? width, double? height}) =>
      SizedBox(width: width, height: height, child: this);

  /// Expands this widget inside a [Flex] parent.
  Widget expanded({int flex = 1}) => Expanded(flex: flex, child: this);

  /// Makes this widget [Flexible] inside a [Flex] parent.
  Widget flexible({int flex = 1, FlexFit fit = FlexFit.loose}) =>
      Flexible(flex: flex, fit: fit, child: this);

  /// Centers this widget.
  Widget center() => Center(child: this);

  /// Aligns this widget within its parent.
  Widget align(AlignmentGeometry alignment) =>
      Align(alignment: alignment, child: this);

  /// Returns this widget when [isVisible], otherwise [replacement].
  Widget visible({
    required bool isVisible,
    Widget replacement = const SizedBox.shrink(),
  }) =>
      isVisible ? this : replacement;

  /// Applies [Opacity] with [value].
  Widget opacity(double value) => Opacity(opacity: value, child: this);

  /// Wraps this widget in an [InkWell] that calls [onTap].
  Widget onTap(
    VoidCallback? onTap, {
    BorderRadius? borderRadius,
  }) =>
      InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: this,
      );

  /// Wraps this widget in an [IgnorePointer].
  Widget ignorePointer({bool ignoring = true}) =>
      IgnorePointer(ignoring: ignoring, child: this);

  /// Clips this widget with rounded corners.
  Widget clipRRect({BorderRadius borderRadius = BorderRadius.zero}) =>
      ClipRRect(borderRadius: borderRadius, child: this);

  /// Wraps this widget in a [Card].
  Widget card({
    Color? color,
    double elevation = 1,
    EdgeInsetsGeometry? margin,
    ShapeBorder? shape,
  }) =>
      Card(
        color: color,
        elevation: elevation,
        margin: margin,
        shape: shape,
        child: this,
      );
}

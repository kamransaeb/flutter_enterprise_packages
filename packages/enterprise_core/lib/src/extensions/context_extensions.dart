import 'package:flutter/material.dart';

/// Convenience accessors for theme, media, navigation, and messaging.
extension ContextExtensions on BuildContext {
  /// The [ThemeData] from the nearest [Theme] ancestor.
  ThemeData get theme => Theme.of(this);

  /// Text styles from [theme].
  TextTheme get textTheme => theme.textTheme;

  /// Color scheme from [theme].
  ColorScheme get colorScheme => theme.colorScheme;

  /// The [MediaQueryData] for this context.
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Screen width in logical pixels.
  double get screenWidth => mediaQuery.size.width;

  /// Screen height in logical pixels.
  double get screenHeight => mediaQuery.size.height;

  /// Top safe-area inset (status bar).
  double get statusBarHeight => mediaQuery.padding.top;

  /// Bottom safe-area inset.
  double get bottomPadding => mediaQuery.padding.bottom;

  /// Current device orientation.
  Orientation get orientation => mediaQuery.orientation;

  /// Device pixel ratio from [mediaQuery].
  double get devicePixelRatio => mediaQuery.devicePixelRatio;

  /// Safe-area padding from [mediaQuery].
  EdgeInsets get padding => mediaQuery.padding;

  /// Parts of the display obscured by system UI (e.g. keyboard).
  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  /// The nearest [NavigatorState].
  NavigatorState get navigator => Navigator.of(this);

  /// Pushes [route] onto the navigator.
  Future<T?> push<T>(Route<T> route) => navigator.push(route);

  /// Pushes a named route onto the navigator.
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) =>
      navigator.pushNamed(routeName, arguments: arguments);

  /// Replaces the current route with a named route.
  Future<T?> pushReplacementNamed<T, TO>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) =>
      navigator.pushReplacementNamed(
        routeName,
        arguments: arguments,
        result: result,
      );

  /// Pops the current route, optionally with [result].
  void pop<T>([T? result]) => navigator.pop(result);

  /// The current [Locale] from [Localizations].
  Locale get locale => Localizations.localeOf(this);

  /// Whether text direction is right-to-left.
  bool get isRTL => Directionality.of(this) == TextDirection.rtl;

  /// The nearest [FocusScopeNode].
  FocusScopeNode get focusScope => FocusScope.of(this);

  /// Unfocuses the current focus scope.
  void unfocus() => focusScope.unfocus();

  /// The nearest [ScaffoldState].
  ScaffoldState get scaffold => Scaffold.of(this);

  /// The nearest [ScaffoldMessengerState].
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  /// Shows a floating snack bar with [message].
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    Color? textColor,
  }) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor),
        ),
        backgroundColor: backgroundColor ?? colorScheme.primary,
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Shows an error-styled snack bar with [message].
  void showErrorSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: colorScheme.error,
      textColor: colorScheme.onError,
    );
  }

  /// Shows a success-styled snack bar with [message].
  void showSuccessSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: colorScheme.primary,
      textColor: colorScheme.onPrimary,
    );
  }

  /// Whether the screen width is under 600 logical pixels.
  bool get isMobile => screenWidth < 600;

  /// Whether the screen width is between 600 and 900 logical pixels.
  bool get isTablet => screenWidth >= 600 && screenWidth < 900;

  /// Whether the screen width is at least 900 logical pixels.
  bool get isDesktop => screenWidth >= 900;

  /// Picks a width value for the current breakpoint.
  double responsiveWidth(double mobile, double tablet, double desktop) {
    if (isMobile) return mobile;
    if (isTablet) return tablet;
    return desktop;
  }

  /// Picks a height value for the current breakpoint.
  double responsiveHeight(double mobile, double tablet, double desktop) {
    if (isMobile) return mobile;
    if (isTablet) return tablet;
    return desktop;
  }
}

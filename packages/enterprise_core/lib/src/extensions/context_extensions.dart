import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  // Theme
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  
  // MediaQuery
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  double get screenWidth => mediaQuery.size.width;
  double get screenHeight => mediaQuery.size.height;
  double get statusBarHeight => mediaQuery.padding.top;
  double get bottomPadding => mediaQuery.padding.bottom;
  Orientation get orientation => mediaQuery.orientation;
  double get devicePixelRatio => mediaQuery.devicePixelRatio;
  EdgeInsets get padding => mediaQuery.padding;
  EdgeInsets get viewInsets => mediaQuery.viewInsets;
  
  // Navigation
  NavigatorState get navigator => Navigator.of(this);
  Future<T?> push<T>(Route<T> route) => navigator.push(route);
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) =>
      navigator.pushNamed(routeName, arguments: arguments);
  Future<T?> pushReplacementNamed<T, TO>(String routeName, {TO? result, Object? arguments}) =>
      navigator.pushReplacementNamed(routeName, arguments: arguments, result: result);
  void pop<T>([T? result]) => navigator.pop(result);
  
  // Localization
  Locale get locale => Localizations.localeOf(this);
  bool get isRTL => Directionality.of(this) == TextDirection.rtl;
  
  // Focus
  FocusScopeNode get focusScope => FocusScope.of(this);
  void unfocus() => focusScope.unfocus();
  
  // Scaffold
  ScaffoldState get scaffold => Scaffold.of(this);
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);
  
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
  
  void showErrorSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: colorScheme.error,
      textColor: colorScheme.onError,
    );
  }
  
  void showSuccessSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: colorScheme.primary,
      textColor: colorScheme.onPrimary,
    );
  }
  
  // Responsive helpers
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 900;
  bool get isDesktop => screenWidth >= 900;
  
  double responsiveWidth(double mobile, double tablet, double desktop) {
    if (isMobile) return mobile;
    if (isTablet) return tablet;
    return desktop;
  }
  
  double responsiveHeight(double mobile, double tablet, double desktop) {
    if (isMobile) return mobile;
    if (isTablet) return tablet;
    return desktop;
  }
}
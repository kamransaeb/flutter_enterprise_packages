part of 'theme_bloc.dart';

/// The status of the theme.
enum AppThemeStatus {
  /// Light theme.
  light,

  /// Dark theme.
  dark,

  /// System theme.
  system;

  /// Returns the display name for the current status.
  String get displayName => switch (this) {
    light => 'Light',
    dark => 'Dark',
    system => 'System',
  };

  /// Returns the icon for the current status.
  IconData get icon => switch (this) {
    light => Icons.light_mode,
    dark => Icons.dark_mode,
    system => Icons.settings,
  };

  /// Returns the [ThemeMode] for the current status.
  ThemeMode get themeMode => switch (this) {
    light => ThemeMode.light,
    dark => ThemeMode.dark,
    system => ThemeMode.system,
  };
}

/// Current theme preferences.
@freezed
abstract class ThemeState with _$ThemeState {
  /// Creates a [ThemeState].
  const factory ThemeState({
    @Default(AppThemeStatus.system) AppThemeStatus currentThemeStatus,
    @Default(false) bool useDynamicColor,
    @Default(1.0) double fontSizeScale,
    @Default(false) bool useHighContrast,
  }) = _StateInitial;

  const ThemeState._();

  /// Whether the current theme is a light theme.
  bool get isLightTheme =>
      currentThemeStatus == AppThemeStatus.light ||
      (currentThemeStatus == AppThemeStatus.system &&
          WidgetsBinding.instance.platformDispatcher.platformBrightness ==
              Brightness.light);

  /// Whether the current theme is a dark theme.
  bool get isDarkTheme =>
      currentThemeStatus == AppThemeStatus.dark ||
      (currentThemeStatus == AppThemeStatus.system &&
          WidgetsBinding.instance.platformDispatcher.platformBrightness ==
              Brightness.dark);
}

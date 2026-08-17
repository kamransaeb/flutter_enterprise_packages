// A sealed class is a type that can only be subclassed in the same library
// (usually same file). The compiler then knows every subtype.
// The compiler then knows every subtype. That’s what makes 
// exhaustive switch work, if you forget a case, you get a compile error.

part of 'theme_bloc.dart';

/// Events for [ThemeBloc].
@freezed
abstract class ThemeEvent with _$ThemeEvent {
  const ThemeEvent._();

  /// Emitted when the theme is loaded.
  const factory ThemeEvent.loaded() = _EventLoaded;

  /// Emitted when the theme is changed.
  const factory ThemeEvent.changed({
    required AppThemeStatus themeStatus,
  }) = _EventChanged;

  /// Emitted when the theme is toggled.
  const factory ThemeEvent.toggleRequested(ThemeMode mode) =
   _EventToggleRequested;

  /// Emitted when the dynamic color is toggled.
  const factory ThemeEvent.dynamicColorToggled({
    required bool enabled,
  }) = _EventDynamicColorToggled;

  /// Emitted when the font size is scaled.
  const factory ThemeEvent.fontSizeScaled({
    required double scale,
  }) = _EventFontSizeScaled;

  /// Emitted when the high contrast is toggled.
  const factory ThemeEvent.hightContrastToggled({
    required bool enabled,
  }) = _EventHighContrastToggled;

  const factory ThemeEvent.resetToDefault() = _EventResetToDefault;
}

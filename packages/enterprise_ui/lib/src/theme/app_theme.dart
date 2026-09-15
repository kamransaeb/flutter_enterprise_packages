import 'package:flutter/material.dart';

/// Shared Material 3 themes. Brand seed comes from the consumer app.
class AppTheme {
  const AppTheme._();

  /// Shared corner radius used by buttons / inputs / cards.
  //static const double radius = 12;

  /// Light theme from the app-supplied [seed], [radius] and [borderWidth].
  static ThemeData light({
    required Color seed,
    double radius = 12,
    double borderWidth = 1.2,
  }) => _fromSeed(seed, Brightness.light, radius, borderWidth);

  /// Dark theme from the app-supplied [seed], [radius] and [borderWidth].
  static ThemeData dark({
    required Color seed,
    double radius = 12,
    double borderWidth = 1.2,
  }) => _fromSeed(seed, Brightness.dark, radius, borderWidth);

  static ThemeData _fromSeed(
    Color seed,
    Brightness brightness,
    double radius,
    double borderWidth,
  ) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
      // Preserves seed color matching
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    );
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
    );
    final onSurfaceVariant = TextStyle(color: colorScheme.onSurfaceVariant);
    final focusedBorderWidth = borderWidth * 2;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      visualDensity: VisualDensity.standard,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: shape,
        color: colorScheme.surfaceContainerLowest,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
        hintStyle: onSurfaceVariant,
        labelStyle: onSurfaceVariant,
        floatingLabelStyle: TextStyle(color: colorScheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: colorScheme.outline,
            width: borderWidth,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant,
            width: borderWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: focusedBorderWidth,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: borderWidth,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: focusedBorderWidth,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(shape: shape),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: shape,
          side: BorderSide(
            color: colorScheme.outline,
            width: borderWidth,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(shape: shape),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: shape,
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: TextStyle(color: colorScheme.onInverseSurface),
        actionTextColor: colorScheme.inversePrimary,
      ),
      dialogTheme: DialogThemeData(
        shape: shape,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: borderWidth,
      ),
    );
  }
}

import 'package:computacion_movil/core/core.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColorsExtension.dark.background,
    colorScheme: ColorScheme.dark(
      primary: AppColorsExtension.dark.primary,
      surface: AppColorsExtension.dark.surface,
      error: AppColorsExtension.dark.error,
      onPrimary: AppColorsExtension.dark.textOnPrimary,
      onSurface: AppColorsExtension.dark.textPrimary,
    ),
    extensions: const [AppColorsExtension.dark],
  );

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColorsExtension.light.background,
    colorScheme: ColorScheme.light(
      primary: AppColorsExtension.light.primary,
      surface: AppColorsExtension.light.surface,
      error: AppColorsExtension.light.error,
      onPrimary: AppColorsExtension.light.textOnPrimary,
      onSurface: AppColorsExtension.light.textPrimary,
    ),
    extensions: const [AppColorsExtension.light],
  );
}

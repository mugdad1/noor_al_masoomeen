import 'package:flutter/material.dart';
import 'colors.dart';

ThemeData _baseTheme({
  required Brightness brightness,
  required Color seedColor,
  required Color background,
  required Color surface,
  required Color foreground,
}) {
  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    fontFamily: 'Inter',
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    ),
    scaffoldBackgroundColor: background,
    appBarTheme: AppBarTheme(
      backgroundColor: surface,
      foregroundColor: foreground,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: surface,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

ThemeData lightTheme = _baseTheme(
  brightness: Brightness.light,
  seedColor: AppColors.primary,
  background: AppColors.backgroundLight,
  surface: AppColors.surfaceLight,
  foreground: AppColors.textPrimary,
);

ThemeData darkTheme = _baseTheme(
  brightness: Brightness.dark,
  seedColor: AppColors.manqabah,
  background: AppColors.backgroundDark,
  surface: AppColors.surfaceDark,
  foreground: AppColors.textPrimaryDark,
);

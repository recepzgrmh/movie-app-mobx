import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'component_themes/app_component_themes.dart';
import 'component_themes/chip_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData dark() {
    final scheme = const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.redLight,
      onPrimary: AppColors.white,
      secondary: AppColors.grayDark,
      onSecondary: AppColors.white,
      surface: AppColors.black,
      onSurface: AppColors.white,
      error: AppColors.redLight,
      onError: AppColors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: AppTypography.textTheme(scheme),
      elevatedButtonTheme: AppComponentThemes.elevatedButtonTheme(),
      chipTheme: AppChipTheme.chipTheme(),
    );
  }
}

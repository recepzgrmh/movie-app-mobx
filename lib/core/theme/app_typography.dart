import 'package:flutter/material.dart';

class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Inter';

  // Headline Styles
  static const headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static const headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
  );

  static const headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  // Title Styles
  static const titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  static const titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  static const titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
  );

  // Body Styles
  static const bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  static const bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  static const bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  // Label Styles
  static const labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  static const labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  static const labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  // Button Text Style
  static const button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  // Chip Text Style
  static const chip = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.0, // Figma line height 100%
  );

  static TextTheme textTheme(ColorScheme scheme) {
    return TextTheme(
      headlineLarge: headlineLarge.copyWith(color: scheme.onSurface),
      headlineMedium: headlineMedium.copyWith(color: scheme.onSurface),
      headlineSmall: headlineSmall.copyWith(color: scheme.onSurface),
      titleLarge: titleLarge.copyWith(color: scheme.onSurface),
      titleMedium: titleMedium.copyWith(color: scheme.onSurface),
      titleSmall: titleSmall.copyWith(color: scheme.onSurface),
      bodyLarge: bodyLarge.copyWith(color: scheme.onSurface),
      bodyMedium: bodyMedium.copyWith(color: scheme.onSurface),
      bodySmall: bodySmall.copyWith(
        color: scheme.onSurface.withValues(alpha: 0.7),
      ),
      labelLarge: labelLarge.copyWith(color: scheme.onSurface),
      labelMedium: labelMedium.copyWith(color: scheme.onSurface),
      labelSmall: labelSmall.copyWith(
        color: scheme.onSurface.withValues(alpha: 0.6),
      ),
    );
  }
}

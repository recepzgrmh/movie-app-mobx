import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../app_dimens.dart';
import '../app_radius.dart';
import '../app_typography.dart';

class AppComponentThemes {
  AppComponentThemes._();

  static ElevatedButtonThemeData elevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
        ),

        minimumSize: const WidgetStatePropertyAll(
          Size(AppDimens.buttonWidth, AppDimens.buttonHeight),
        ),

        textStyle: WidgetStatePropertyAll(AppTypography.button),

        alignment: Alignment.center,

        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) return AppColors.redDark;
          if (states.contains(WidgetState.disabled)) return AppColors.gray;
          return AppColors.redLight;
        }),

        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) return AppColors.gray;
          if (states.contains(WidgetState.disabled)) return AppColors.grayDark;
          return AppColors.white;
        }),

        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.black.withValues(alpha: 0.08);
          }
          return null;
        }),

        padding: const WidgetStatePropertyAll(
          EdgeInsets.only(
            left: AppDimens.buttonPaddingLeft,
            top: AppDimens.buttonPadding,
            bottom: AppDimens.buttonPadding,
            right: AppDimens.buttonPadding,
          ),
        ),

        elevation: const WidgetStatePropertyAll(0),
      ),
    );
  }
}

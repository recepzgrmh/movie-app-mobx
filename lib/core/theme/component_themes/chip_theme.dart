import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../app_dimens.dart';
import '../app_typography.dart';

class AppChipTheme {
  AppChipTheme._();

  static ChipThemeData chipTheme() {
    return ChipThemeData(
      // Figma renkleri
      backgroundColor: AppColors.gray,
      selectedColor: AppColors.redLight,
      // Label stilleri
      labelStyle: AppTypography.chip.copyWith(
        color: AppColors.black,
        height: 1.0,
      ),
      secondaryLabelStyle: AppTypography.chip.copyWith(
        color: AppColors.white,
        height: 1.0,
      ),

      // Check ikon
      showCheckmark: true,
      checkmarkColor: AppColors.white,

      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.chipPaddingHorizontal,
        vertical: AppDimens.chipPaddingVertical,
      ),

      shape: const StadiumBorder(),
    );
  }

  static BoxConstraints get chipConstraints =>
      const BoxConstraints(minHeight: AppDimens.chipHeight);
}

class AppChipStyles {
  AppChipStyles._();

  static BoxDecoration get defaultChip => BoxDecoration(
    color: AppColors.gray,
    borderRadius: BorderRadius.circular(16),
  );

  static BoxDecoration get selectedChip => BoxDecoration(
    color: AppColors.redLight,
    borderRadius: BorderRadius.circular(16),
  );

  // Unselected padding
  static const unselectedPadding = EdgeInsets.symmetric(
    horizontal: AppDimens.chipPaddingHorizontal,
    vertical: AppDimens.chipPaddingVertical,
  );

  // Selected padding
  static const selectedPadding = EdgeInsets.symmetric(
    horizontal: AppDimens.chipPaddingHorizontalSelected,
    vertical: AppDimens.chipPaddingVertical,
  );

  static const chipSize = Size(double.infinity, AppDimens.chipHeight);
}

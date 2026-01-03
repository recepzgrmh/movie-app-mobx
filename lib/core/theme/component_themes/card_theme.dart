import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../app_dimens.dart';
import '../app_radius.dart';

/// Image card stilleri için helper class
class AppCardStyles {
  AppCardStyles._();

  /// Movie Poster Card (Rectangle)
  static BoxDecoration get posterCard => BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.poster),
      );

  /// Movie Poster Card boyutları
  static const posterSize = Size(AppDimens.posterWidth, AppDimens.posterHeight);

  /// Genre Card (Circle)
  static BoxDecoration get genreCard => const BoxDecoration(
        shape: BoxShape.circle,
      );

  /// Genre Card boyutu
  static const genreSize = Size(AppDimens.genreCardSize, AppDimens.genreCardSize);

  /// Poster card with selection state
  static BoxDecoration posterCardWithSelection({required bool isSelected}) =>
      BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.poster),
        border: isSelected
            ? Border.all(
                color: AppColors.redDark,
                width: AppDimens.selectedBorderWidth,
              )
            : null,
      );

  /// Genre card with selection state
  static BoxDecoration genreCardWithSelection({required bool isSelected}) =>
      BoxDecoration(
        shape: BoxShape.circle,
        border: isSelected
            ? Border.all(
                color: AppColors.redDark,
                width: AppDimens.selectedBorderWidth,
              )
            : null,
      );
}

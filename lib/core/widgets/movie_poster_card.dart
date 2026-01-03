import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_radius.dart';

class MoviePosterCard extends StatelessWidget {
  const MoviePosterCard({
    super.key,
    required this.imageUrl,
    this.isSelected = false,
    this.onTap,
    this.child,
  });

  final String imageUrl;
  final bool isSelected;
  final VoidCallback? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppDimens.posterWidth,
        height: AppDimens.posterHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.poster),
          border: isSelected
              ? Border.all(
                  color: AppColors.redDark,
                  width: AppDimens.selectedBorderWidth,
                )
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.poster),
          child:
              child ??
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.gray,
                  child: const Icon(Icons.movie, color: AppColors.grayDark),
                ),
              ),
        ),
      ),
    );
  }
}

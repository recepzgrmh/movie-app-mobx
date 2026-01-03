import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';

class GenreCard extends StatelessWidget {
  const GenreCard({
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
        width: AppDimens.genreCardSize,
        height: AppDimens.genreCardSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(
                  color: AppColors.redDark,
                  width: AppDimens.selectedBorderWidth,
                )
              : null,
        ),
        child: ClipOval(
          child:
              child ??
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.gray,
                  child: const Icon(Icons.category, color: AppColors.grayDark),
                ),
              ),
        ),
      ),
    );
  }
}

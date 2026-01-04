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
    const borderWidth = AppDimens.selectedBorderWidth;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: AppDimens.genreCardSize + 8, // Extra space for checkmark
        height: AppDimens.genreCardSize + 8,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Main circular card with border
            Container(
              width: AppDimens.genreCardSize,
              height: AppDimens.genreCardSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(color: AppColors.redLight, width: borderWidth)
                    : null,
              ),
              child: Padding(
                padding: EdgeInsets.all(isSelected ? borderWidth : 0),
                child: ClipOval(
                  child:
                      child ??
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: AppDimens.genreCardSize,
                        height: AppDimens.genreCardSize,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: AppColors.gray,
                          child: const Icon(
                            Icons.category,
                            color: AppColors.grayDark,
                          ),
                        ),
                      ),
                ),
              ),
            ),
            // Checkmark indicator at bottom right
            if (isSelected)
              Positioned(
                right: 16,
                bottom: 12,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: AppColors.redLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: AppColors.white,
                    size: 18,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_radius.dart';
import 'inner_shadow.dart';

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
    final imageWidget = child ??
        Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: AppColors.gray,
            child: const Icon(Icons.movie, color: AppColors.grayDark),
          ),
        );

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: AppDimens.posterWidth,
        height: AppDimens.posterHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.poster),
        ),
        child: isSelected
            ? InnerShadow(
                color: AppColors.redLight.withValues(alpha: 0.3), // 30% opacity
                blur: 60,
                spread: 24,
                offset: Offset.zero,
                borderRadius: BorderRadius.circular(AppRadius.poster),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    imageWidget,
                    // Checkmark icon in bottom right when selected
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.redLight,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.poster),
                child: imageWidget,
              ),
      ),
    );
  }
}

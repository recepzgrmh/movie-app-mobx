import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';

class CustomPageIndicator extends StatelessWidget {
  final int itemCount;
  final double currentPage;
  final int visibleCount;

  const CustomPageIndicator({
    super.key,
    required this.itemCount,
    required this.currentPage,
    this.visibleCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveVisibleCount = math.min(visibleCount, itemCount);
    final currentIndex = currentPage.round();

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(effectiveVisibleCount, (index) {
          // Show indicators for current position
          final offsetFromCenter = index - (effectiveVisibleCount ~/ 2);
          final actualIndex = currentIndex + offsetFromCenter;

          if (actualIndex < 0 || actualIndex >= itemCount) {
            return const SizedBox.shrink();
          }

          final isActive = actualIndex == currentIndex;
          final distance = (actualIndex - currentPage).abs();

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: AppDimens.spacing4),
            width: isActive ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: isActive
                  ? AppColors.redLight
                  : AppColors.redLight.withValues(
                      alpha: math.max(0.2, 1 - distance * 0.3),
                    ),
            ),
          );
        }),
      ),
    );
  }
}

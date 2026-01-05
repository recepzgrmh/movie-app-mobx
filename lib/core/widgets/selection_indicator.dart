import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SelectionIndicator extends StatelessWidget {
  final bool isSelected;
  final double size;
  const SelectionIndicator({
    super.key,
    required this.isSelected,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.redLight : AppColors.gray,
          width: 2,
        ),
        color: isSelected ? AppColors.redLight : Colors.transparent,
      ),
      child: isSelected
          ? Icon(Icons.check, size: size * 0.66, color: AppColors.white)
          : null,
    );
  }
}

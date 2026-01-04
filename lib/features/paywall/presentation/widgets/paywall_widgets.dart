import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../stores/paywall_store.dart';

class FeatureComparisonTable extends StatefulWidget {
  final SubscriptionPlan selectedPlan;

  const FeatureComparisonTable({super.key, required this.selectedPlan});

  @override
  State<FeatureComparisonTable> createState() => _FeatureComparisonTableState();
}

class _FeatureComparisonTableState extends State<FeatureComparisonTable> {
  static const double _rowHeight = 40.0;
  
  /// Get the row index where the first cross should appear in PRO column
  /// Returns 4 (after last row) if all are checks (yearly)
  int _getCrossStartRow(SubscriptionPlan plan) {
    switch (plan) {
      case SubscriptionPlan.weekly:
        return 2; // Cross starts at Personalized (index 2)
      case SubscriptionPlan.monthly:
        return 3; // Cross starts at Ad-Free (index 3)
      case SubscriptionPlan.yearly:
        return 4; // No crosses visible (after last row)
    }
  }

  @override
  Widget build(BuildContext context) {
    const features = [
      AppStrings.dailyMovieSuggestions,
      AppStrings.aiPoweredInsights,
      AppStrings.personalizedWatchlists,
      AppStrings.adFreeExperience,
    ];

    const freeAvailability = [true, false, false, false];
    final crossStartRow = _getCrossStartRow(widget.selectedPlan);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Features Name Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: _rowHeight),
                ...List.generate(features.length, (index) {
                  return Container(
                    height: _rowHeight,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      features[index],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // FREE Column
          SizedBox(
            width: 60,
            child: Column(
              children: [
                SizedBox(
                  height: _rowHeight,
                  child: Center(
                    child: Text(
                      AppStrings.free,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.white.withValues(alpha: 0.7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ...List.generate(features.length, (index) {
                  return SizedBox(
                    height: _rowHeight,
                    child: Center(
                      child: _StaticIcon(isCheck: freeAvailability[index]),
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // PRO Column with animated sliding crosses
          Container(
            width: 60,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.redLight.withValues(alpha: 0.8),
              ),
              borderRadius: BorderRadius.circular(12),
              color: AppColors.redLight.withValues(alpha: 0.05),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Stack(
                children: [
                  // Background column with header and check icons
                  Column(
                    children: [
                      SizedBox(
                        height: _rowHeight,
                        child: Center(
                          child: Text(
                            AppStrings.pro,
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // Check icons (always there, but covered by crosses when needed)
                      ...List.generate(features.length, (index) {
                        final isVisible = index < crossStartRow;
                        return SizedBox(
                          height: _rowHeight,
                          child: Center(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: isVisible ? 1.0 : 0.0,
                              child: AnimatedScale(
                                duration: const Duration(milliseconds: 300),
                                scale: isVisible ? 1.0 : 0.5,
                                curve: Curves.easeOutBack,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AppColors.success,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.success.withValues(alpha: 0.4),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(Icons.check, size: 14, color: AppColors.black),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  
                  // Sliding crosses overlay
                  ...List.generate(2, (crossIndex) {
                    // crossIndex 0 = first cross, crossIndex 1 = second cross
                    final targetRow = crossStartRow + crossIndex;
                    final isVisible = targetRow < 4; // Only show if within 4 rows
                    
                    return AnimatedPositioned(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOutCubic,
                      top: _rowHeight + (targetRow * _rowHeight) + (_rowHeight - 22) / 2,
                      left: 0,
                      right: 0,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: isVisible ? 1.0 : 0.0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, size: 14, color: AppColors.black),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Static icon (no animation)
class _StaticIcon extends StatelessWidget {
  final bool isCheck;

  const _StaticIcon({required this.isCheck});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isCheck ? AppColors.success : AppColors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(
        isCheck ? Icons.check : Icons.close,
        size: 14,
        color: AppColors.black,
      ),
    );
  }
}

// Subscription Option Card
class SubscriptionOptionCard extends StatelessWidget {
  final String title;
  final String priceMain;
  final String priceSub;
  final bool isSelected;
  final bool isBestValue;
  final VoidCallback onTap;

  const SubscriptionOptionCard({
    super.key,
    required this.title,
    required this.priceMain,
    required this.priceSub,
    required this.isSelected,
    this.isBestValue = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.redLight : AppColors.grayDark,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Radio Indicator
                _RadioIndicator(isSelected: isSelected),
                const SizedBox(width: 16),

                // Titles
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      priceSub,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppColors.gray),
                    ),
                  ],
                ),

                const Spacer(),

                // Price
                Text(
                  priceMain,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Best Value Badge
        if (isBestValue)
          Positioned(
            top: -12,
            right: 0,
            left: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.redLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  AppStrings.bestValue,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _RadioIndicator extends StatelessWidget {
  final bool isSelected;

  const _RadioIndicator({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.redLight : AppColors.gray,
          width: 2,
        ),
        color: isSelected ? AppColors.redLight : Colors.transparent,
      ),
      child: isSelected
          ? const Icon(Icons.check, size: 16, color: AppColors.white)
          : null,
    );
  }
}

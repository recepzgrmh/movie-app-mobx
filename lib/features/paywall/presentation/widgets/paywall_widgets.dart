import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../stores/paywall_store.dart';

class FeatureComparisonTable extends StatelessWidget {
  final SubscriptionPlan selectedPlan;

  const FeatureComparisonTable({super.key, required this.selectedPlan});

  @override
  Widget build(BuildContext context) {
    const features = [
      AppStrings.dailyMovieSuggestions,
      AppStrings.aiPoweredInsights,
      AppStrings.personalizedWatchlists,
      AppStrings.adFreeExperience,
    ];

    // Determine availability based on plan
    final isYearly = selectedPlan == SubscriptionPlan.yearly;

    // True = Check, False = Cross.
    // Index 0 is Free
    // Index 1 is Pro
    final availability = [
      [true, true], // Daily Movie Suggestions
      [false, true], // AI-Powered Movie Insights
      [false, true], // Personalized Watchlists
      [false, isYearly], // Ad-Free Experience (Only yearly has it checked)
    ];

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Features Name Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                ...List.generate(features.length, (index) {
                  return Container(
                    height: 40,
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
                  height: 40,
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
                    height: 40,
                    child: Center(
                      child: _StatusIcon(isAvailable: availability[index][0]),
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // PRO Column (Bordered)
          Container(
            width: 60,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.redLight.withValues(alpha: 0.8),
              ),
              borderRadius: BorderRadius.circular(12),
              color: AppColors.redLight.withValues(alpha: 0.05),
            ),
            child: Column(
              children: [
                // Header PRO
                SizedBox(
                  height: 40,
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
                // Icons
                ...List.generate(features.length, (index) {
                  return SizedBox(
                    height: 40,
                    child: Center(
                      child: _StatusIcon(isAvailable: availability[index][1]),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final bool isAvailable;

  const _StatusIcon({required this.isAvailable});

  @override
  Widget build(BuildContext context) {
    if (isAvailable) {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: AppColors.success,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, size: 14, color: AppColors.black),
      );
    }
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.close, size: 14, color: AppColors.black),
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

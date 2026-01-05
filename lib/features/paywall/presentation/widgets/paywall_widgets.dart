
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../stores/paywall_store.dart';
import 'package:movie_app/core/widgets/selection_indicator.dart';
import '../../../../core/theme/app_dimens.dart';

EdgeInsets paywallBottomPadding(double Function(double) s) =>
    EdgeInsets.only(
      left: s(AppDimens.spacing16),
      right: s(AppDimens.spacing16),
      top: s(AppDimens.spacing16),
      bottom: s(AppDimens.spacing32),
    );

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

    final scale = MediaQuery.sizeOf(context).width / 375.0;
    double s(double v) => v * scale;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Features Name Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: s(_rowHeight)),
                ...List.generate(features.length, (index) {
                  return Container(
                    height: s(_rowHeight),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      features[index],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: s(AppDimens.spacing14),
                        fontFamily: 'Inter',
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // FREE Column
          SizedBox(
            width: s(AppDimens.spacing60),
            child: Column(
              children: [
                SizedBox(
                  height: s(_rowHeight),
                  child: Center(
                    child: Text(
                      AppStrings.free,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.white.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w600,
                        fontSize: s(AppDimens.spacing16),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
                ...List.generate(features.length, (index) {
                  return SizedBox(
                    height: s(_rowHeight),
                    child: Center(
                      child: _StaticIcon(isCheck: freeAvailability[index], s: s),
                    ),
                  );
                }),
              ],
            ),
          ),

          SizedBox(width: s(AppDimens.spacing8)),

          // PRO Column with animated sliding crosses
          Container(
            width: s(AppDimens.spacing60),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.redLight.withValues(alpha: 0.8),
              ),
              borderRadius: BorderRadius.circular(s(AppDimens.radiusMedium)),
              color: AppColors.redLight.withValues(alpha: 0.05),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(s(11)),
              child: Stack(
                children: [
                  // Background column with header and check icons
                  Column(
                    children: [
                      SizedBox(
                        height: s(_rowHeight),
                        child: Center(
                          child: Text(
                            AppStrings.pro,
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: s(AppDimens.spacing16),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                      // Check icons (always there, but covered by crosses when needed)
                      ...List.generate(features.length, (index) {
                        final isVisible = index < crossStartRow;
                        return SizedBox(
                          height: s(_rowHeight),
                          child: Center(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: isVisible ? 1.0 : 0.0,
                              child: AnimatedScale(
                                duration: const Duration(milliseconds: 300),
                                scale: isVisible ? 1.0 : 0.5,
                                curve: Curves.easeOutBack,
                                child: Container(
                                  padding: EdgeInsets.all(s(AppDimens.spacing4)),
                                  decoration: BoxDecoration(
                                    color: AppColors.success,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.success.withValues(alpha: 0.4),
                                        blurRadius: s(AppDimens.spacing6),
                                      ),
                                    ],
                                  ),
                                  child: Icon(Icons.check, size: s(AppDimens.spacing14), color: AppColors.black),
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
                      top: s(_rowHeight) + (targetRow * s(_rowHeight)) + (s(_rowHeight) - s(AppDimens.spacing22)) / 2,
                      left: 0,
                      right: 0,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: isVisible ? 1.0 : 0.0,
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(s(AppDimens.spacing4)),
                            decoration: const BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.close, size: s(AppDimens.spacing14), color: AppColors.black),
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
  final double Function(double) s;

  const _StaticIcon({required this.isCheck, required this.s});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(s(AppDimens.spacing4)),
      decoration: BoxDecoration(
        color: isCheck ? AppColors.success : AppColors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(
        isCheck ? Icons.check : Icons.close,
        size: s(AppDimens.spacing14),
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
    final scale = MediaQuery.sizeOf(context).width / 375.0;
    double s(double v) => v * scale;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: s(AppDimens.spacing60),
            padding: EdgeInsets.symmetric(horizontal: s(AppDimens.spacing20)),
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(s(AppDimens.radiusMedium)),
              border: Border.all(
                color: isSelected ? AppColors.redLight : AppColors.grayDark,
                width: s(1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side: Radio + Titles
                Expanded(
                  child: Row(
                    children: [
                      SelectionIndicator(isSelected: isSelected, size: s(AppDimens.spacing24)),
                      SizedBox(width: s(AppDimens.spacing16)),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: s(AppDimens.spacing16),
                                fontFamily: 'Inter',
                              ),
                            ),
                            SizedBox(height: s(AppDimens.spacing4)),
                            Text(
                              priceSub,
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color: AppColors.gray,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Price
                Text(
                  priceMain,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: s(AppDimens.spacing16),
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ),

        // Best Value Badge
        if (isBestValue)
          Positioned(
            top: -s(AppDimens.spacing12),
            right: 0,
            left: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: s(AppDimens.spacing12),
                  vertical: s(AppDimens.spacing4),
                ),
                decoration: BoxDecoration(
                  color: AppColors.redLight,
                  borderRadius: BorderRadius.circular(s(AppDimens.radiusMedium)),
                ),
                child: Text(
                  AppStrings.bestValue,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: s(AppDimens.spacing12),
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class PaywallFooterLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final TextStyle? style;

  const PaywallFooterLink({super.key, required this.text, required this.onTap, this.style});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Builder(
        builder: (context) {
          final scale = MediaQuery.sizeOf(context).width / 375.0;
          double s(double v) => v * scale;

          return Text(
            text,
            style:
                style ??
                Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.gray,
                  fontSize: s(AppDimens.spacing8),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                ),
          );
        },
      ),
    );
  }
}

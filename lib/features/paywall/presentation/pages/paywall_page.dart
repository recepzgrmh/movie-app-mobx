import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/app/di/di.dart';
import 'package:movie_app/app/router/routes.dart';
import 'package:movie_app/core/constants/app_strings.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/paywall/presentation/stores/paywall_store.dart';
import 'package:movie_app/features/paywall/presentation/widgets/paywall_widgets.dart';

class PaywallPage extends StatefulWidget {
  const PaywallPage({super.key});

  @override
  State<PaywallPage> createState() => _PaywallPageState();
}

class _PaywallPageState extends State<PaywallPage> {
  late final PaywallStore _store;

  @override
  void initState() {
    super.initState();
    _store = getIt<PaywallStore>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 220),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Header with Close Button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () => context.go(AppRoutes.home),
                          icon: const Icon(Icons.close, color: AppColors.white),
                        ),
                      ],
                    ),
                  ),

                  // Title
                  Text(
                    AppStrings.appName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Feature Comparison Table
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Observer(
                      builder: (_) => FeatureComparisonTable(
                        selectedPlan: _store.selectedPlan,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Free Trial Toggle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Observer(
                      builder: (_) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.redLight.withValues(alpha: 0.5),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.enableFreeTrial,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                            ),
                            Switch.adaptive(
                              value: _store.isFreeTrialEnabled,
                              onChanged: _store.toggleFreeTrial,
                              activeTrackColor: AppColors.success,
                              inactiveTrackColor: AppColors.grayDark.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Subscription Options
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Observer(
                      builder: (_) => Column(
                        children: [
                          SubscriptionOptionCard(
                            title: AppStrings.weekly,
                            priceMain: AppStrings.pricePerWeek('\$4,99'),
                            priceSub: AppStrings.onlyPricePerWeek('\$4,99'),
                            isSelected:
                                _store.selectedPlan == SubscriptionPlan.weekly,
                            onTap: () =>
                                _store.selectPlan(SubscriptionPlan.weekly),
                          ),
                          const SizedBox(height: 16),
                          SubscriptionOptionCard(
                            title: AppStrings.monthly,
                            priceMain: AppStrings.pricePerMonth('\$11,99'),
                            priceSub: AppStrings.onlyPricePerWeek('\$2,99'),
                            isSelected:
                                _store.selectedPlan == SubscriptionPlan.monthly,
                            onTap: () =>
                                _store.selectPlan(SubscriptionPlan.monthly),
                          ),
                          const SizedBox(height: 24),
                          SubscriptionOptionCard(
                            title: AppStrings.yearly,
                            priceMain: AppStrings.pricePerYear('\$49,99'),
                            priceSub: AppStrings.onlyPricePerWeek('\$0,96'),
                            isSelected:
                                _store.selectedPlan == SubscriptionPlan.yearly,
                            isBestValue: true,
                            onTap: () =>
                                _store.selectPlan(SubscriptionPlan.yearly),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Fixed Bottom Area
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 32,
              ),
              decoration: BoxDecoration(
                color: AppColors.black,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.verified_user_outlined,
                          size: 16,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppStrings.autoRenewable,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.gray),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Unlock Button
                    Observer(
                      builder: (_) => SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _store.isLoading ? null : _store.purchase,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.redLight,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: _store.isLoading
                              ? const CircularProgressIndicator(
                                  color: AppColors.white,
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _store.isFreeTrialEnabled
                                          ? AppStrings.threeDaysFree
                                          : AppStrings.unlockMovieAiPro,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.white,
                                          ),
                                    ),
                                    if (_store.isFreeTrialEnabled)
                                      Text(
                                        AppStrings.noPaymentNow,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: AppColors.white.withValues(
                                                alpha: 0.8,
                                              ),
                                              fontSize: 12,
                                            ),
                                      ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Footer Links
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _FooterLink(
                            text: AppStrings.termsOfUse,
                            onTap: () {},
                          ),
                          _FooterLink(
                            text: AppStrings.restorePurchase,
                            onTap: () {},
                          ),
                          _FooterLink(
                            text: AppStrings.privacyPolicy,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _FooterLink({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: AppColors.gray, fontSize: 10),
      ),
    );
  }
}

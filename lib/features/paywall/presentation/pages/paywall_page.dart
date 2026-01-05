

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/app/di/di.dart';
import 'package:movie_app/app/router/routes.dart';
import 'package:movie_app/core/constants/app_strings.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/paywall/presentation/pages/exit_paywall_view.dart';
import 'package:movie_app/features/paywall/presentation/stores/paywall_store.dart';
import 'package:movie_app/features/paywall/presentation/widgets/paywall_widgets.dart';
import 'package:movie_app/core/widgets/glowing_button.dart';
import '../../../../core/theme/app_dimens.dart';

class PaywallPage extends StatefulWidget {
  const PaywallPage({super.key});

  @override
  State<PaywallPage> createState() => _PaywallPageState();
}

class _PaywallPageState extends State<PaywallPage>
    with SingleTickerProviderStateMixin {
  late final PaywallStore _store;
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  bool _showExitOffer = false;

  @override
  void initState() {
    super.initState();
    _store = getIt<PaywallStore>();

    // Entry animation
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: FadeTransition(
        opacity: _fadeAnimation,

        child: Stack(
          children: [
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.spacing4,
                      vertical: AppDimens.spacing8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (_showExitOffer) {
                              context.go(AppRoutes.home);
                            } else {
                              setState(() => _showExitOffer = true);
                            }
                          },
                          icon: const Icon(Icons.close, color: AppColors.white),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Title
                          Text(
                            AppStrings.appName,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: AppDimens.spacing24,
                                  fontFamily: 'Inter',
                                  color: AppColors.white,
                                ),
                          ),
                          const SizedBox(height: AppDimens.spacing24),

                          // Feature Table
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacing20),
                            child: Observer(
                              builder: (_) => FeatureComparisonTable(
                                selectedPlan: _store.selectedPlan,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppDimens.spacing32),

                          // Free Trial Toggle
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacing20),
                            child: Observer(
                              builder: (_) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimens.spacing20,
                                  vertical: AppDimens.spacing8,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.redLight.withValues(
                                      alpha: 0.5,
                                    ),
                                    width: _store.isFreeTrialEnabled ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                                  color: Colors.transparent,
                                ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppStrings.enableFreeTrial,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: AppDimens.spacing16,
                                            fontFamily: 'Inter',
                                            color: AppColors.white,
                                          ),
                                    ),
                                    Switch.adaptive(
                                      value: _store.isFreeTrialEnabled,
                                      onChanged: _store.toggleFreeTrial,
                                      activeTrackColor: AppColors.success,
                                      inactiveTrackColor: AppColors.grayDark
                                          .withValues(alpha: 0.3),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppDimens.spacing32),

                          // Plans
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacing20),
                            child: Observer(
                              builder: (_) => Column(
                                children: [
                                  SubscriptionOptionCard(
                                    title: AppStrings.weekly,
                                    priceMain: AppStrings.pricePerWeek(
                                      '\$4,99',
                                    ),
                                    priceSub: AppStrings.onlyPricePerWeek(
                                      '\$4,99',
                                    ),
                                    isSelected:
                                        _store.selectedPlan ==
                                        SubscriptionPlan.weekly,
                                    onTap: () => _store.selectPlan(
                                      SubscriptionPlan.weekly,
                                    ),
                                  ),
                                  const SizedBox(height: AppDimens.spacing16),
                                  SubscriptionOptionCard(
                                    title: AppStrings.monthly,
                                    priceMain: AppStrings.pricePerMonth(
                                      '\$11,99',
                                    ),
                                    priceSub: AppStrings.onlyPricePerWeek(
                                      '\$2,99',
                                    ),
                                    isSelected:
                                        _store.selectedPlan ==
                                        SubscriptionPlan.monthly,
                                    onTap: () => _store.selectPlan(
                                      SubscriptionPlan.monthly,
                                    ),
                                  ),
                                  const SizedBox(height: AppDimens.spacing24),
                                  SubscriptionOptionCard(
                                    title: AppStrings.yearly,
                                    priceMain: AppStrings.pricePerYear(
                                      '\$49,99',
                                    ),
                                    priceSub: AppStrings.onlyPricePerWeek(
                                      '\$0,96',
                                    ),
                                    isSelected:
                                        _store.selectedPlan ==
                                        SubscriptionPlan.yearly,
                                    isBestValue: true,
                                    onTap: () => _store.selectPlan(
                                      SubscriptionPlan.yearly,
                                    ),
                                  ),
                                  const SizedBox(height: AppDimens.spacing16),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: AppDimens.spacing24),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Section
                  SafeArea(
                    top: false,
                    child: Container(
                      padding: paywallBottomPadding((v) => v),
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.verified_user_outlined,
                                size: AppDimens.spacing16,
                                color: AppColors.success,
                              ),
                              const SizedBox(width: AppDimens.spacing8),
                              Text(
                                AppStrings.autoRenewable,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: AppColors.gray,
                                      fontSize: AppDimens.spacing10,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Inter',
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppDimens.spacing16),
                          Observer(
                            builder: (_) => GlowingButton(
                              isLoading: _store.isLoading,
                              enableGlow: _store.isFreeTrialEnabled,
                              onPressed: _store.purchase,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _store.isFreeTrialEnabled
                                        ? AppStrings.threeDaysFree
                                        : AppStrings.unlockMovieAiPro,
                                    style: Theme.of(context).textTheme.titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: AppDimens.spacing16,
                                          fontFamily: 'Inter',
                                          color: AppColors.white,
                                        ),
                                  ),
                                  if (_store.isFreeTrialEnabled)
                                    Text(
                                      AppStrings.noPaymentNow,
                                      style: Theme.of(context).textTheme.bodySmall
                                          ?.copyWith(
                                            color: AppColors.white.withValues(
                                              alpha: 0.8,
                                            ),
                                            fontSize: AppDimens.spacing14,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Inter',
                                          ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: AppDimens.spacing16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacing20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                PaywallFooterLink(
                                  text: AppStrings.termsOfUse,
                                  onTap: () {},
                                ),
                                PaywallFooterLink(
                                  text: AppStrings.restorePurchase,
                                  onTap: () {},
                                ),
                                PaywallFooterLink(
                                  text: AppStrings.privacyPolicy,
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppDimens.spacing8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Exit offer overlay
            if (_showExitOffer)
              Positioned.fill(
                child: ExitPaywallView(
                  store: _store,
                  onClose: () => context.go(AppRoutes.home),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

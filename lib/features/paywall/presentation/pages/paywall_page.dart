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

class _PaywallPageState extends State<PaywallPage>
    with SingleTickerProviderStateMixin {
  late final PaywallStore _store;
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;

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
                            icon: const Icon(
                              Icons.close,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Title
                    Text(
                      AppStrings.appName,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
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
                              width: _store.isFreeTrialEnabled ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.transparent,
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
                                inactiveTrackColor: AppColors.grayDark
                                    .withValues(alpha: 0.3),
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
                                  _store.selectedPlan ==
                                  SubscriptionPlan.weekly,
                              onTap: () =>
                                  _store.selectPlan(SubscriptionPlan.weekly),
                            ),
                            const SizedBox(height: 16),
                            SubscriptionOptionCard(
                              title: AppStrings.monthly,
                              priceMain: AppStrings.pricePerMonth('\$11,99'),
                              priceSub: AppStrings.onlyPricePerWeek('\$2,99'),
                              isSelected:
                                  _store.selectedPlan ==
                                  SubscriptionPlan.monthly,
                              onTap: () =>
                                  _store.selectPlan(SubscriptionPlan.monthly),
                            ),
                            const SizedBox(height: 24),
                            SubscriptionOptionCard(
                              title: AppStrings.yearly,
                              priceMain: AppStrings.pricePerYear('\$49,99'),
                              priceSub: AppStrings.onlyPricePerWeek('\$0,96'),
                              isSelected:
                                  _store.selectedPlan ==
                                  SubscriptionPlan.yearly,
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

                      // Unlock Button with glow
                      Observer(
                        builder: (_) => _GlowingButton(
                          isLoading: _store.isLoading,
                          isFreeTrialEnabled: _store.isFreeTrialEnabled,
                          onPressed: _store.purchase,
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
      ),
    );
  }
}

/// Button with animated glow and width pulse effect
class _GlowingButton extends StatefulWidget {
  final bool isLoading;
  final bool isFreeTrialEnabled;
  final VoidCallback onPressed;

  const _GlowingButton({
    required this.isLoading,
    required this.isFreeTrialEnabled,
    required this.onPressed,
  });

  @override
  State<_GlowingButton> createState() => _GlowingButtonState();
}

class _GlowingButtonState extends State<_GlowingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  late Animation<double> _widthAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.7,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _widthAnimation = Tween<double>(
      begin: 335,
      end: 375,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Start animation only if free trial is enabled
    if (widget.isFreeTrialEnabled) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(_GlowingButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Start/stop animation when free trial changes
    if (widget.isFreeTrialEnabled && !oldWidget.isFreeTrialEnabled) {
      _controller.repeat(reverse: true);
    } else if (!widget.isFreeTrialEnabled && oldWidget.isFreeTrialEnabled) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAnimating = widget.isFreeTrialEnabled;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final width = isAnimating ? _widthAnimation.value : 355.0;
        final glowAlpha = isAnimating ? _glowAnimation.value : 0.3;

        return Center(
          child: Container(
            width: width,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.redLight.withValues(alpha: glowAlpha),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : widget.onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.redLight,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.isFreeTrialEnabled
                              ? AppStrings.threeDaysFree
                              : AppStrings.unlockMovieAiPro,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                        ),
                        if (widget.isFreeTrialEnabled)
                          Text(
                            AppStrings.noPaymentNow,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.white.withValues(alpha: 0.8),
                                  fontSize: 12,
                                ),
                          ),
                      ],
                    ),
            ),
          ),
        );
      },
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


import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/app/router/routes.dart';
import 'package:movie_app/core/constants/app_strings.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_dimens.dart';
import 'package:movie_app/core/widgets/glowing_button.dart';
import 'package:movie_app/features/paywall/presentation/stores/paywall_store.dart';
import 'package:movie_app/features/paywall/presentation/widgets/paywall_widgets.dart';
import 'package:movie_app/core/widgets/selection_indicator.dart';

class PaywallVariantB extends StatelessWidget {
  final PaywallStore store;

  const PaywallVariantB({super.key, required this.store});

  void _onClose(BuildContext context) {
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    // Base reference: 375x812
    final scale = size.width / 375.0;
    double s(double v) => v * scale;

    final topInset = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: AppColors.black),
            ),
          ),

          // Vignette + vertical fade
          const Positioned.fill(child: PaywallVignette()),

          // UI layer
          Positioned.fill(
            child: Stack(
              children: [
                // Close button
                Positioned(
                  top: topInset + s(AppDimens.spacing6),
                  right: s(AppDimens.spacing10),
                  child: InkResponse(
                    onTap: () => _onClose(context),
                    radius: s(AppDimens.spacing22),
                    child: Icon(Icons.close, color: AppColors.white, size: s(AppDimens.spacing22)),
                  ),
                ),

                // Center content: AppName + benefits
                Align(
                  alignment: const Alignment(0, -0.15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppStrings.appName,
                        style: TextStyle(
                          fontSize: s(24),
                          height: 1.0,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white.withValues(alpha: 0.90),
                        ),
                      ),
                      SizedBox(height: s(AppDimens.spacing26)),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _checkItem(s, AppStrings.dailyMovieSuggestions),
                              SizedBox(height: s(AppDimens.spacing18)),
                              _checkItem(s, AppStrings.aiPoweredInsights),
                              SizedBox(height: s(AppDimens.spacing18)),
                              _checkItem(s, AppStrings.personalizedWatchlists),
                              SizedBox(height: s(AppDimens.spacing18)),
                              _checkItem(s, AppStrings.adFreeExperience),
                              SizedBox(
                                height: s(AppDimens.spacing42),
                              ), // More margin for separation
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Bottom block: plans + button + footer
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: paywallBottomPadding(s),
                      child: Observer(
                        builder: (_) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ExitSubscriptionCard(
                              height: s(60),
                              title: AppStrings.monthly,
                              price: '\$2.99 / week',
                              subtitle: '\$11.99/month',
                              isSelected:
                                  store.selectedPlan == SubscriptionPlan.monthly,
                              onTap: () =>
                                  store.selectPlan(SubscriptionPlan.monthly),
                            ),
                            SizedBox(height: s(AppDimens.spacing12)),
                            ExitSubscriptionCard(
                              height: s(60),
                              title: AppStrings.yearly,
                              price: '\$0.96 / week',
                              subtitle: '\$44.99/month',
                              isSelected:
                                  store.selectedPlan == SubscriptionPlan.yearly,
                              isBestValue: true,
                              onTap: () =>
                                  store.selectPlan(SubscriptionPlan.yearly),
                            ),
                            SizedBox(height: s(AppDimens.spacing18)),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: s(16),
                                  color: AppColors.success,
                                ),
                                SizedBox(width: s(AppDimens.spacing8)),
                                Text(
                                  AppStrings.autoRenewable,
                                  style: TextStyle(
                                    fontSize: s(10),
                                    height: 1.0,
                                    color: AppColors.gray.withValues(alpha: 0.95),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: s(AppDimens.spacing14)),

                            // Continue Button
                            GlowingButton(
                              isLoading: store.isLoading,
                              enableGlow: false,
                              onPressed: store.purchase,
                              child: Stack(
                                children: [
                                  Center(
                                    child: Text(
                                      AppStrings.continueText,
                                      style: TextStyle(
                                        fontSize: s(18),
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: s(AppDimens.spacing18)),
                                      child: Icon(
                                        Icons.arrow_forward,
                                        size: s(AppDimens.spacing20),
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: s(AppDimens.spacing18)),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                PaywallFooterLink(
                                  text: AppStrings.termsOfUse,
                                  onTap: () {},
                                  style: TextStyle(
                                    fontSize: s(8),
                                    height: 1.0,
                                    color: AppColors.white.withValues(alpha: 0.55),
                                  ),
                                ),
                                PaywallFooterLink(
                                  text: AppStrings.restorePurchase,
                                  onTap: () {},
                                  style: TextStyle(
                                    fontSize: s(8),
                                    height: 1.0,
                                    color: AppColors.white.withValues(alpha: 0.55),
                                  ),
                                ),
                                PaywallFooterLink(
                                  text: AppStrings.privacyPolicy,
                                  onTap: () {},
                                  style: TextStyle(
                                    fontSize: s(8),
                                    height: 1.0,
                                    color: AppColors.white.withValues(alpha: 0.55),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: s(AppDimens.spacing6)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkItem(double Function(double) s, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.check,
          color: AppColors.white.withValues(alpha: 0.90),
          size: s(AppDimens.spacing22),
        ),
        SizedBox(width: s(AppDimens.spacing16)),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: s(AppDimens.spacing15), // Slightly larger for readability
              height: 1.0,
              fontWeight: FontWeight.w600,
              color: AppColors.white.withValues(alpha: 0.90),
            ),
          ),
        ),
      ],
    );
  }
}

class PaywallVignette extends StatelessWidget {
  const PaywallVignette({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top->Bottom fade
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.black.withValues(alpha: 0.18),
                  AppColors.black.withValues(alpha: 0.70),
                  AppColors.black.withValues(alpha: 0.92),
                ],
                stops: const [0.0, 0.55, 1.0],
              ),
            ),
          ),
        ),

        // Right->Left focus
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  AppColors.black.withValues(alpha: 0.70),
                  AppColors.black.withValues(alpha: 0.10),
                ],
                stops: const [0.0, 0.55],
              ),
            ),
          ),
        ),

        // Side vignette
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.black.withValues(alpha: 0.40),
                  Colors.transparent,
                  AppColors.black.withValues(alpha: 0.40),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ExitSubscriptionCard extends StatelessWidget {
  final double height;
  final String title;
  final String price;
  final String subtitle;
  final bool isSelected;
  final bool isBestValue;
  final VoidCallback onTap;

  const ExitSubscriptionCard({
    super.key,
    required this.height,
    required this.title,
    required this.price,
    required this.subtitle,
    required this.isSelected,
    this.isBestValue = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.sizeOf(context).width / 375.0;
    double s(double v) => v * scale;

    final borderColor = isSelected
        ? AppColors.redLight
        : AppColors.white.withValues(alpha: 0.35);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(s(AppDimens.radiusMedium)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(
                height: height,
                padding: EdgeInsets.symmetric(horizontal: s(20)),
                decoration: BoxDecoration(
                  color: AppColors.black.withValues(alpha: 0.30),
                  borderRadius: BorderRadius.circular(s(AppDimens.radiusMedium)),
                  border: Border.all(color: borderColor, width: s(1)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.25),
                      blurRadius: s(AppDimens.spacing18),
                      offset: Offset(0, s(AppDimens.spacing8)),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Radio
                    SelectionIndicator(isSelected: isSelected, size: s(AppDimens.spacing22)),
                    SizedBox(width: s(AppDimens.spacing14)),

                    // Texts
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: s(AppDimens.spacing16),
                              height: 1.0,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                          SizedBox(height: s(AppDimens.spacing6)),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: s(AppDimens.spacing12),
                              height: 1.0,
                              color: AppColors.white.withValues(alpha: 0.45),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Price
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: s(AppDimens.spacing16),
                        height: 1.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        if (isBestValue)
          Positioned(
            top: -s(12),
            right: s(AppDimens.spacing18),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: s(AppDimens.spacing12), vertical: s(5)),
              decoration: BoxDecoration(
                color: AppColors.redLight,
                borderRadius: BorderRadius.circular(s(AppDimens.spacing14)),
              ),
              child: Text(
                AppStrings.bestValue,
                style: TextStyle(
                  fontSize: s(AppDimens.spacing12),
                  height: 1.0,
                  color: AppColors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

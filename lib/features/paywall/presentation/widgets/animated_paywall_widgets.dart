// lib/features/paywall/presentation/widgets/animated_paywall_widgets.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../stores/paywall_store.dart';

/// Animated Free Trial Toggle with scale and color transitions
class AnimatedFreeTrialToggle extends StatelessWidget {
  final bool isEnabled;
  final ValueChanged<bool> onChanged;

  const AnimatedFreeTrialToggle({
    super.key,
    required this.isEnabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isEnabled
              ? AppColors.success.withValues(alpha: 0.8)
              : AppColors.redLight.withValues(alpha: 0.5),
          width: isEnabled ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isEnabled
            ? AppColors.success.withValues(alpha: 0.1)
            : Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppStrings.enableFreeTrial,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          _AnimatedSwitch(value: isEnabled, onChanged: onChanged),
        ],
      ),
    );
  }
}

/// Custom animated switch with smooth transitions
class _AnimatedSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _AnimatedSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutBack,
        width: 52,
        height: 28,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: value
              ? AppColors.success
              : AppColors.grayDark.withValues(alpha: 0.3),
          boxShadow: value
              ? [
                  BoxShadow(
                    color: AppColors.success.withValues(alpha: 0.4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutBack,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Animated Subscription Card with scale and glow effects
class AnimatedSubscriptionCard extends StatefulWidget {
  final String title;
  final String priceMain;
  final String priceSub;
  final bool isSelected;
  final bool isBestValue;
  final VoidCallback onTap;
  final int animationDelay;

  const AnimatedSubscriptionCard({
    super.key,
    required this.title,
    required this.priceMain,
    required this.priceSub,
    required this.isSelected,
    this.isBestValue = false,
    required this.onTap,
    this.animationDelay = 0,
  });

  @override
  State<AnimatedSubscriptionCard> createState() =>
      _AnimatedSubscriptionCardState();
}

class _AnimatedSubscriptionCardState extends State<AnimatedSubscriptionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.isSelected && widget.isBestValue) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(AnimatedSubscriptionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && widget.isBestValue) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: widget.isSelected && widget.isBestValue
                  ? _pulseAnimation.value
                  : 1.0,
              child: child,
            );
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: widget.onTap,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: widget.isSelected
                        ? AppColors.redLight.withValues(alpha: 0.1)
                        : AppColors.black,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: widget.isSelected
                          ? AppColors.redLight
                          : AppColors.grayDark,
                      width: widget.isSelected ? 2.5 : 1,
                    ),
                    boxShadow: widget.isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.redLight.withValues(alpha: 0.3),
                              blurRadius: 12,
                              spreadRadius: 0,
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      // Animated Radio Indicator
                      _AnimatedRadioIndicator(isSelected: widget.isSelected),
                      const SizedBox(width: 16),

                      // Titles
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: widget.isSelected
                                        ? AppColors.white
                                        : AppColors.white.withValues(
                                            alpha: 0.9,
                                          ),
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.priceSub,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.gray),
                            ),
                          ],
                        ),
                      ),

                      // Price
                      Text(
                        widget.priceMain,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: widget.isSelected
                                  ? AppColors.redLight
                                  : AppColors.white,
                            ),
                      ),
                    ],
                  ),
                ),
              ),

              // Animated Best Value Badge
              if (widget.isBestValue)
                Positioned(
                  top: -12,
                  right: 0,
                  left: 0,
                  child: Center(
                    child:
                        Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.redDark,
                                    AppColors.redLight,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.redLight.withValues(
                                      alpha: 0.5,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                AppStrings.bestValue,
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            )
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .scaleXY(begin: 1.0, end: 1.05, duration: 800.ms),
                  ),
                ),
            ],
          ),
        )
        .animate(delay: Duration(milliseconds: widget.animationDelay))
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic);
  }
}

/// Animated Radio Indicator with scale and check mark animation
class _AnimatedRadioIndicator extends StatelessWidget {
  final bool isSelected;

  const _AnimatedRadioIndicator({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.redLight : AppColors.gray,
          width: isSelected ? 0 : 2,
        ),
        gradient: isSelected
            ? const LinearGradient(
                colors: [AppColors.redDark, AppColors.redLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.redLight.withValues(alpha: 0.5),
                  blurRadius: 6,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) =>
            ScaleTransition(scale: animation, child: child),
        child: isSelected
            ? const Icon(
                Icons.check,
                size: 16,
                color: AppColors.white,
                key: ValueKey('check'),
              )
            : const SizedBox.shrink(key: ValueKey('empty')),
      ),
    );
  }
}

/// Animated CTA Button with pulse/glow effect
class AnimatedUnlockButton extends StatefulWidget {
  final bool isLoading;
  final bool isFreeTrialEnabled;
  final VoidCallback onPressed;

  const AnimatedUnlockButton({
    super.key,
    required this.isLoading,
    required this.isFreeTrialEnabled,
    required this.onPressed,
  });

  @override
  State<AnimatedUnlockButton> createState() => _AnimatedUnlockButtonState();
}

class _AnimatedUnlockButtonState extends State<AnimatedUnlockButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.redLight.withValues(
                  alpha: _glowAnimation.value,
                ),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: child,
        );
      },
      child: SizedBox(
        width: double.infinity,
        height: 56,
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
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.3),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      ),
                      child: Text(
                        widget.isFreeTrialEnabled
                            ? AppStrings.threeDaysFree
                            : AppStrings.unlockMovieAiPro,
                        key: ValueKey(widget.isFreeTrialEnabled),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                      ),
                    ),
                    if (widget.isFreeTrialEnabled)
                      Text(
                        AppStrings.noPaymentNow,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.white.withValues(alpha: 0.8),
                          fontSize: 12,
                        ),
                      ).animate().fadeIn(delay: 100.ms, duration: 200.ms),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Animated Feature Comparison Table
class AnimatedFeatureTable extends StatelessWidget {
  final SubscriptionPlan selectedPlan;

  const AnimatedFeatureTable({super.key, required this.selectedPlan});

  @override
  Widget build(BuildContext context) {
    const features = [
      AppStrings.dailyMovieSuggestions,
      AppStrings.aiPoweredInsights,
      AppStrings.personalizedWatchlists,
      AppStrings.adFreeExperience,
    ];

    final isYearly = selectedPlan == SubscriptionPlan.yearly;

    final availability = [
      [true, true],
      [false, true],
      [false, true],
      [false, isYearly],
    ];

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Features Column
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
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                        ),
                      )
                      .animate(
                        delay: Duration(milliseconds: 100 + (index * 80)),
                      )
                      .fadeIn(duration: 300.ms);
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
                ).animate(delay: 200.ms).fadeIn(),
                ...List.generate(features.length, (index) {
                  return SizedBox(
                    height: 40,
                    child: Center(
                      child: _AnimatedStatusIcon(
                        isAvailable: availability[index][0],
                        delay: 300 + (index * 80),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // PRO Column
          Container(
                width: 60,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.redLight.withValues(alpha: 0.8),
                  ),
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.redLight.withValues(alpha: 0.15),
                      AppColors.redLight.withValues(alpha: 0.05),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                          height: 40,
                          child: Center(
                            child: Text(
                              AppStrings.pro,
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        )
                        .animate(delay: 250.ms)
                        .fadeIn()
                        .shimmer(duration: 1500.ms, delay: 500.ms),
                    ...List.generate(features.length, (index) {
                      return SizedBox(
                        height: 40,
                        child: Center(
                          child: _AnimatedStatusIcon(
                            isAvailable: availability[index][1],
                            delay: 350 + (index * 80),
                            isPro: true,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              )
              .animate(delay: 150.ms)
              .fadeIn()
              .scaleXY(begin: 0.95, end: 1, curve: Curves.easeOutBack),
        ],
      ),
    );
  }
}

/// Animated Status Icon with pop-in effect
class _AnimatedStatusIcon extends StatelessWidget {
  final bool isAvailable;
  final int delay;
  final bool isPro;

  const _AnimatedStatusIcon({
    required this.isAvailable,
    required this.delay,
    this.isPro = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isAvailable ? AppColors.success : AppColors.white,
            shape: BoxShape.circle,
            boxShadow: isAvailable && isPro
                ? [
                    BoxShadow(
                      color: AppColors.success.withValues(alpha: 0.4),
                      blurRadius: 6,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            isAvailable ? Icons.check : Icons.close,
            size: 14,
            color: AppColors.black,
          ),
        )
        .animate(delay: Duration(milliseconds: delay))
        .scaleXY(begin: 0, end: 1, curve: Curves.easeOutBack, duration: 300.ms);
  }
}

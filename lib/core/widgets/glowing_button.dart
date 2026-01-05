import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GlowingButton extends StatefulWidget {
  final bool isLoading;
  final bool enableGlow;
  final VoidCallback onPressed;
  final Widget child;

  const GlowingButton({
    super.key,
    required this.isLoading,
    this.enableGlow = false,
    required this.onPressed,
    required this.child,
  });

  @override
  State<GlowingButton> createState() => _GlowingButtonState();
}

class _GlowingButtonState extends State<GlowingButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    if (widget.enableGlow) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(GlowingButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.enableGlow && !oldWidget.enableGlow) {
      _controller.repeat();
    } else if (!widget.enableGlow && oldWidget.enableGlow) {
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = MediaQuery.sizeOf(context).width / 375.0;
        double s(double v) => v * scale;

        const minWBase = 335.0;
        const maxDeltaBase = 40.0;

        final double minW = math.min(s(minWBase), constraints.maxWidth);
        final double maxWWanted = minW + s(maxDeltaBase);

        final double maxW = math.min(maxWWanted, constraints.maxWidth);

        final double amplitude = (maxW - minW).clamp(0.0, double.infinity);

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // 0..1..0 triangle wave
            final t = _controller.value;
            final tri = t < 0.5 ? (t * 2.0) : ((1.0 - t) * 2.0);

            final double width = widget.enableGlow
                ? (minW + amplitude * tri)
                : minW;

            return Center(
              child: SizedBox(
                width: width,
                height: s(56),
                child: ElevatedButton(
                  onPressed: widget.isLoading ? null : widget.onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.redLight,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(s(16)),
                    ),
                    elevation: 0,
                  ),
                  child: widget.isLoading
                      ? SizedBox(
                          width: s(24),
                          height: s(24),
                          child: const CircularProgressIndicator(
                            color: AppColors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : widget.child,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

class InnerShadow extends StatelessWidget {
  final Widget child;
  final Color color;
  final double blur;
  final double spread;
  final Offset offset;
  final BorderRadius borderRadius;

  const InnerShadow({
    super.key,
    required this.child,
    required this.color,
    required this.blur,
    required this.spread,
    this.offset = Offset.zero,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Stack(
        children: [
          child,
          Positioned.fill(
            child: CustomPaint(
              painter: _InnerShadowPainter(
                color: color,
                blur: blur,
                spread: spread,
                offset: offset,
                borderRadius: borderRadius,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InnerShadowPainter extends CustomPainter {
  final Color color;
  final double blur;
  final double spread;
  final Offset offset;
  final BorderRadius borderRadius;

  _InnerShadowPainter({
    required this.color,
    required this.blur,
    required this.spread,
    required this.offset,
    required this.borderRadius,
  });

  double _sigma(double radius) => radius * 0.57735 + 0.5;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final outer = borderRadius.toRRect(rect);
    final innerRect = rect.deflate(spread);
    final inner = borderRadius.toRRect(innerRect);

    final shadowPaint = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, _sigma(blur));

    canvas.saveLayer(rect, Paint());

    // shadow
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.drawRRect(outer, shadowPaint);
    canvas.restore();

    // blur ile yumuşak geçiş
    final cutoutPaint = Paint()
      ..blendMode = BlendMode.dstOut
      ..color = Colors.black
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, _sigma(blur * 0.6));

    canvas.drawRRect(inner, cutoutPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _InnerShadowPainter old) {
    return old.color != color ||
        old.blur != blur ||
        old.spread != spread ||
        old.offset != offset ||
        old.borderRadius != borderRadius;
  }
}

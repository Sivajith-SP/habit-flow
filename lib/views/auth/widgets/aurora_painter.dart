import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

/// Paints a green-to-yellow aurora: vivid emerald orbs on top, warm
/// amber/yellow orbs at the bottom, blending in the middle — exactly
/// like the reference design.
class AuroraPainter extends CustomPainter {
  final double progress;

  const AuroraPainter({required this.progress});

  double _sin(double t) => math.sin(t * math.pi * 2);
  double _cos(double t) => math.cos(t * math.pi * 2);

  @override
  void paint(Canvas canvas, Size size) {
    final p = progress;

    // ── TOP REGION — rich greens ──────────────────────────────────────────

    // Orb 1: primary green, top-left
    _drawOrb(
      canvas, size,
      cx: size.width * (.15 + .09 * _sin(p)),
      cy: size.height * (.08 + .06 * _cos(p * .8)),
      radius: size.width * .55,
      color: AppColors.primary,         // 0xFF4CAF50
      alpha: .22,
    );

    // Orb 2: bright lime-green, top-right
    _drawOrb(
      canvas, size,
      cx: size.width * (.85 + .07 * _cos(p * .9 + .3)),
      cy: size.height * (.06 + .07 * _sin(p * .75 + .2)),
      radius: size.width * .52,
      color: const Color(0xFF8BC34A),   // lime green
      alpha: .18,
    );

    // Orb 3: mint / light green, top-centre
    _drawOrb(
      canvas, size,
      cx: size.width * (.50 + .11 * _sin(p * 1.1 + .5)),
      cy: size.height * (.16 + .06 * _cos(p * 1.0 + .1)),
      radius: size.width * .46,
      color: const Color(0xFFA5D6A7),   // light green
      alpha: .15,
    );

    // ── BOTTOM REGION — warm yellows / amber ─────────────────────────────

    // Orb 4: soft yellow, bottom-right
    _drawOrb(
      canvas, size,
      cx: size.width * (.82 + .08 * _sin(p * .85 + .45)),
      cy: size.height * (.88 + .05 * _cos(p * .9 + .2)),
      radius: size.width * .54,
      color: const Color(0xFFFFEB3B),   // yellow
      alpha: .20,
    );

    // Orb 5: warm amber/gold, bottom-left
    _drawOrb(
      canvas, size,
      cx: size.width * (.18 + .09 * _cos(p * .75 + .6)),
      cy: size.height * (.90 + .05 * _sin(p * .8 + .4)),
      radius: size.width * .52,
      color: const Color(0xFFFFC107),   // amber
      alpha: .18,
    );

    // Orb 6: pale lemon, bottom-centre
    _drawOrb(
      canvas, size,
      cx: size.width * (.50 + .12 * _sin(p * .95 + .8)),
      cy: size.height * (.82 + .06 * _cos(p * .85 + .35)),
      radius: size.width * .48,
      color: const Color(0xFFFFF176),   // lemon yellow
      alpha: .15,
    );

    // ── WAVE BANDS ───────────────────────────────────────────────────────

    // Band 1 (upper) — green to mint
    _drawWaveBand(
      canvas, size,
      baseY: size.height * .20,
      amplitude: 45,
      thickness: 165,
      phase: p,
      color1: AppColors.primary,
      color2: const Color(0xFF81C784),
      glowBase: .12,
    );

    // Band 2 (upper-mid) — lime to light green
    _drawWaveBand(
      canvas, size,
      baseY: size.height * .38,
      amplitude: 40,
      thickness: 145,
      phase: p + .28,
      color1: const Color(0xFF8BC34A),
      color2: const Color(0xFFC5E1A5),
      glowBase: .09,
    );

    // Band 3 (lower-mid) — yellow-green transition
    _drawWaveBand(
      canvas, size,
      baseY: size.height * .58,
      amplitude: 38,
      thickness: 145,
      phase: p + .52,
      color1: const Color(0xFFCDDC39),  // yellow-lime
      color2: const Color(0xFFFFEE58),  // soft yellow
      glowBase: .09,
    );

    // Band 4 (lower) — amber to yellow
    _drawWaveBand(
      canvas, size,
      baseY: size.height * .78,
      amplitude: 50,
      thickness: 185,
      phase: p + .70,
      color1: const Color(0xFFFFC107),
      color2: const Color(0xFFFFEB3B),
      glowBase: .10,
    );
  }

  void _drawOrb(
    Canvas canvas,
    Size size, {
    required double cx,
    required double cy,
    required double radius,
    required Color color,
    required double alpha,
  }) {
    final paint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 85)
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: alpha),
          color.withValues(alpha: alpha * .50),
          Colors.transparent,
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(
        Rect.fromCircle(center: Offset(cx, cy), radius: radius),
      );

    canvas.drawCircle(Offset(cx, cy), radius, paint);
  }

  void _drawWaveBand(
    Canvas canvas,
    Size size, {
    required double baseY,
    required double amplitude,
    required double thickness,
    required double phase,
    required Color color1,
    required Color color2,
    required double glowBase,
  }) {
    final wave = _sin(phase);
    final y = baseY + wave * 20;
    final glow = glowBase + .08 * _sin(phase * .7);
    final blur = 68 + 28 * _sin(phase * 1.1);

    final path = Path()
      ..moveTo(-120, y)
      ..cubicTo(
        size.width * .15, y - amplitude,
        size.width * .32, y + amplitude,
        size.width * .50, y,
      )
      ..cubicTo(
        size.width * .68, y - amplitude,
        size.width * .84, y + amplitude,
        size.width + 120, y,
      );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = thickness
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur)
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.transparent,
          color1.withValues(alpha: glow * .55),
          color1.withValues(alpha: glow),
          color2.withValues(alpha: glow),
          color2.withValues(alpha: glow * .55),
          Colors.transparent,
        ],
        stops: const [0.0, 0.15, 0.40, 0.60, 0.85, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant AuroraPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
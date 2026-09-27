import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme/app_flow_tokens.dart';

/// Animated circular progress ring.
/// [size] defaults to 108.r (original spec). Pass a smaller value for compact layouts.
class ProgressRing extends StatelessWidget {
  final double progress;   // 0.0 – 1.0
  final int percentage;    // pre-computed for display
  /// Diameter of the ring in logical pixels (already scaled by caller, e.g. 90.r).
  final double? size;

  const ProgressRing({
    super.key,
    required this.progress,
    required this.percentage,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final disableAnimations = MediaQuery.of(context).disableAnimations;
    final double diameter = size ?? 108.r;

    final trackColor =
        Colors.white.withValues(alpha: isDark ? 0.18 : 0.45);

    return SizedBox(
      width: diameter,
      height: diameter,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: progress),
        duration: disableAnimations
            ? Duration.zero
            : const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        builder: (context, animValue, _) {
          final displayPct = (animValue * 100).round();
          // Scale font proportionally to ring diameter
          final fontSize = (diameter * 0.24).clamp(18.0, 28.0);
          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(diameter, diameter),
                painter: _RingPainter(
                  progress: animValue,
                  trackColor: trackColor,
                  progressColor: tokens.accent,
                  strokeWidth: (diameter * 0.105).clamp(8.0, 13.0),
                ),
              ),
              Text(
                '$displayPct%',
                style: GoogleFonts.urbanist(
                  fontSize: fontSize.spMin,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  height: 1.1,
                  color: tokens.text,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;
  final double strokeWidth;

  const _RingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    if (progress > 0.0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress.clamp(0.0, 1.0),
        false,
        Paint()
          ..color = progressColor
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = strokeWidth,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress ||
      old.trackColor != trackColor ||
      old.progressColor != progressColor ||
      old.strokeWidth != strokeWidth;
}

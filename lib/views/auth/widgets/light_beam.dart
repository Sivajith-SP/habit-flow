import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

/// Light beams tinted in green and soft yellow to match the aurora palette.
class LightBeam extends StatelessWidget {
  final double progress;

  const LightBeam({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final t = Curves.easeInOut.transform(progress);

    return IgnorePointer(
      child: Stack(
        children: [
          //------------------------------------------------------
          // Beam 1 — primary green (top)
          //------------------------------------------------------
          Positioned(
            top: -200,
            left: -120 + 140 * math.sin(t * math.pi * 2),
            child: Transform.rotate(
              angle: -0.38,
              child: _Beam(
                width: 800,
                height: 200,
                opacity: .12,
                color: AppColors.primary,
              ),
            ),
          ),

          //------------------------------------------------------
          // Beam 2 — warm yellow (bottom)
          //------------------------------------------------------
          Positioned(
            bottom: -220,
            right: -100 + 120 * math.cos(t * math.pi * 2),
            child: Transform.rotate(
              angle: .32,
              child: _Beam(
                width: 700,
                height: 175,
                opacity: .10,
                color: const Color(0xFFFFEB3B),
              ),
            ),
          ),

          //------------------------------------------------------
          // Beam 3 — lime green (mid)
          //------------------------------------------------------
          Positioned(
            top: _screenHeight(context) * .30,
            left: -140 + 100 * math.sin((t + .5) * math.pi * 2),
            child: Transform.rotate(
              angle: -0.10,
              child: _Beam(
                width: 580,
                height: 140,
                opacity: .07,
                color: const Color(0xFF8BC34A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
}

class _Beam extends StatelessWidget {
  final double width;
  final double height;
  final double opacity;
  final Color color;

  const _Beam({
    required this.width,
    required this.height,
    required this.opacity,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height),
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              color.withValues(alpha: opacity * .30),
              color.withValues(alpha: opacity),
              color.withValues(alpha: opacity * .30),
              Colors.transparent,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
    );
  }
}
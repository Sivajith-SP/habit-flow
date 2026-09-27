import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_flow_tokens.dart';

/// Celebration card shown in the habits section when every habit is done.
/// Matches the "All done for today" design from the reference image.
class AllDoneCard extends StatelessWidget {
  final VoidCallback? onViewStats;

  const AllDoneCard({super.key, this.onViewStats});

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: isDark ? Border.all(color: tokens.border, width: 1) : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Confetti + checkmark ring
          SizedBox(
            width: 110.r,
            height: 110.r,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Confetti sparkles
                ..._confettiDots(tokens),

                // Outer glow ring
                Container(
                  width: 78.r,
                  height: 78.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: tokens.accent.withValues(alpha: isDark ? 0.18 : 0.20),
                  ),
                ),

                // Inner accent circle with check
                Container(
                  width: 60.r,
                  height: 60.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: tokens.accent,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check_rounded,
                      color: tokens.onAccent,
                      size: 30.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 18.h),

          // Title
          Text(
            'All done for today',
            style: AppUrbanist.sectionTitle(color: tokens.text).copyWith(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 8.h),

          // Subtitle
          Text(
            "Every habit is checked off. Rest up, we'll be back tomorrow.",
            style: AppUrbanist.body(color: tokens.mutedText),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 18.h),

          // "View my stats" link
          GestureDetector(
            onTap: onViewStats ?? () {},
            behavior: HitTestBehavior.opaque,
            child: Text(
              'View my stats',
              style: AppUrbanist.body(
                color: tokens.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Generates small colourful confetti dots positioned around the ring.
  List<Widget> _confettiDots(HabitFlowTokens tokens) {
    // [angle in degrees, distance from center, color]
    final dots = [
      (20.0,  44.0, tokens.tilePinkIcon),
      (70.0,  40.0, tokens.tileMintIcon),
      (130.0, 46.0, tokens.tileLavenderIcon),
      (160.0, 42.0, tokens.tileButterIcon),
      (200.0, 44.0, tokens.tilePinkIcon),
      (250.0, 40.0, tokens.tileMintIcon),
      (300.0, 46.0, tokens.tileButterIcon),
      (340.0, 42.0, tokens.tileLavenderIcon),
    ];

    return dots.map((dot) {
      final rad = dot.$1 * math.pi / 180;
      final dist = dot.$2.r;
      final color = dot.$3;

      return Positioned(
        left: 55.r + dist * math.cos(rad) - 4.r,
        top:  55.r + dist * math.sin(rad) - 4.r,
        child: Container(
          width: 7.r,
          height: 7.r,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      );
    }).toList();
  }
}

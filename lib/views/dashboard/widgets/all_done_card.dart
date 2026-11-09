import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_flow_tokens.dart';

/// Celebration card shown in the habits section when every habit is done.
/// Enhanced with delightful entrance bounce, pulsating glow, and floating sparkles.
class AllDoneCard extends StatefulWidget {
  final VoidCallback? onViewStats;

  const AllDoneCard({super.key, this.onViewStats});

  @override
  State<AllDoneCard> createState() => _AllDoneCardState();
}

class _AllDoneCardState extends State<AllDoneCard>
    with TickerProviderStateMixin {
  late final AnimationController _entranceCtrl;
  late final AnimationController _pulseCtrl;

  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scaleAnimation = Tween<double>(begin: 0.65, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

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
        boxShadow: isDark ? null : tokens.cardShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated Confetti + checkmark ring
          AnimatedBuilder(
            animation: Listenable.merge([_scaleAnimation, _pulseCtrl]),
            builder: (context, child) {
              final pulseValue = _pulseCtrl.value; // 0.0 -> 1.0
              final glowScale = 1.0 + (pulseValue * 0.08);

              return Transform.scale(
                scale: _scaleAnimation.value,
                child: SizedBox(
                  width: 110.r,
                  height: 110.r,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Confetti sparkles with floating orbit rotation
                      ..._animatedConfettiDots(tokens, pulseValue),

                      // Outer pulsing glow ring
                      Transform.scale(
                        scale: glowScale,
                        child: Container(
                          width: 78.r,
                          height: 78.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: tokens.accent.withValues(
                              alpha: isDark
                                  ? 0.16 + (pulseValue * 0.12)
                                  : 0.18 + (pulseValue * 0.10),
                            ),
                          ),
                        ),
                      ),

                      // Inner accent circle with check
                      Container(
                        width: 60.r,
                        height: 60.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: tokens.accent,
                          boxShadow: [
                            BoxShadow(
                              color: tokens.accent.withValues(alpha: 0.35),
                              blurRadius: 14 + (pulseValue * 6),
                              offset: const Offset(0, 4),
                            ),
                          ],
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
              );
            },
          ),

          SizedBox(height: 18.h),

          // Staggered animated title and texts
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                    onTap: widget.onViewStats ?? () {},
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
            ),
          ),
        ],
      ),
    );
  }

  /// Generates small colourful confetti dots positioned around the ring with micro-drift.
  List<Widget> _animatedConfettiDots(HabitFlowTokens tokens, double pulse) {
    // [baseAngle in degrees, distance, color, driftDirection]
    final dots = [
      (20.0, 44.0, tokens.tilePinkIcon, 1.0),
      (70.0, 40.0, tokens.tileMintIcon, -1.0),
      (130.0, 46.0, tokens.tileLavenderIcon, 1.0),
      (160.0, 42.0, tokens.tileButterIcon, -1.0),
      (200.0, 44.0, tokens.tilePinkIcon, 1.0),
      (250.0, 40.0, tokens.tileMintIcon, -1.0),
      (300.0, 46.0, tokens.tileButterIcon, 1.0),
      (340.0, 42.0, tokens.tileLavenderIcon, -1.0),
    ];

    return dots.map((dot) {
      final baseDeg = dot.$1;
      final dist = (dot.$2 + (pulse * 3.0)).r;
      final color = dot.$3;
      final drift = dot.$4 * pulse * 8.0; // gentle angle orbit sway
      final rad = (baseDeg + drift) * math.pi / 180;

      return Positioned(
        left: 55.r + dist * math.cos(rad) - 4.r,
        top: 55.r + dist * math.sin(rad) - 4.r,
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

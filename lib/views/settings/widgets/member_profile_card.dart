import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_flow_tokens.dart';

/// A purple gradient "Member Profile" ID card matching the exact design spec:
///
/// - 3-stop linear gradient (light/dark mode variants)
/// - Two decorative semi-transparent circles (top-right, bottom-left)
/// - MEMBER PROFILE label + rounded-square chevron button
/// - 62×62 rounded-square avatar + name / email block
/// - Dashed horizontal divider
/// - HABITFLOW ID strip with dynamic formatted ID value
class MemberProfileCard extends StatelessWidget {
  /// Display name shown in the card (e.g. "Sivajith").
  final String fullName;

  /// Email address shown below the name.
  final String email;

  /// Formatted HabitFlow ID string (e.g. "HF · 2026 · 0417").
  final String habitflowId;

  /// Called when the card is tapped. Typically navigates to the profile screen.
  final VoidCallback? onTap;

  const MemberProfileCard({
    super.key,
    required this.fullName,
    required this.email,
    required this.habitflowId,
    this.onTap,
  });

  // ── Private helpers ────────────────────────────────────────────────────────

  static Widget _circle(double size, {required double alpha}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: alpha),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final initial = fullName.trim().isNotEmpty
        ? fullName.trim()[0].toUpperCase()
        : 'H';

    // Light: #6C53C9 → #8B6FE0 → #A78BE8  (≈ 135°)
    // Dark:  #3A2E6E → #5A46A8 → #7A64C9
    final gradientColors = isDark
        ? const [Color(0xFF3A2E6E), Color(0xFF5A46A8), Color(0xFF7A64C9)]
        : const [Color(0xFF6C53C9), Color(0xFF8B6FE0), Color(0xFFA78BE8)];

    return ClipRRect(
      borderRadius: BorderRadius.circular(26.r),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              // Alignment(0.7, 1.0) approximates a 135° direction
              begin: Alignment.topLeft,
              end: const Alignment(0.7, 1.0),
              colors: gradientColors,
              stops: const [0.0, 0.55, 1.0],
            ),
            borderRadius: BorderRadius.circular(26.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF553CBE).withValues(alpha: 0.28),
                blurRadius: 30,
                offset: Offset(0, 14.h),
              ),
            ],
          ),
          child: InkWell(
            onTap: onTap,
            splashColor: Colors.white.withValues(alpha: 0.08),
            highlightColor: Colors.white.withValues(alpha: 0.04),
            child: Stack(
              // StackFit.passthrough: Stack inherits parent width constraint
              // but lets its height flow from the non-Positioned Column child.
              // Positioned circles are overlay decorations only — they do not
              // affect layout sizing, so there is no unbounded-height issue.
              fit: StackFit.passthrough,
              clipBehavior: Clip.hardEdge,
              children: [
                // ── Decorative circle 1 — large, top-right ──────────────
                Positioned(
                  top: -70.r,
                  right: -50.r,
                  child: _circle(180.r, alpha: 0.08),
                ),

                // ── Decorative circle 2 — small, bottom-left ────────────
                Positioned(
                  bottom: -50.r,
                  left: -30.r,
                  child: _circle(120.r, alpha: 0.06),
                ),

                // ── Card content (non-Positioned → drives Stack height) ─
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 18.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Top row: MEMBER PROFILE + chevron button
                      _TopRow(),

                      SizedBox(height: 16.h),

                      // Main row: avatar + name/email
                      _MainRow(initial: initial, fullName: fullName, email: email),

                      // Dashed divider with top margin
                      Padding(
                        padding: EdgeInsets.only(top: 18.h, bottom: 12.h),
                        child: const _DashedDivider(),
                      ),

                      // Bottom row: HABITFLOW ID label + value
                      _BottomRow(habitflowId: habitflowId),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets (private, co-located for clarity)
// ─────────────────────────────────────────────────────────────────────────────

/// Top row: "MEMBER PROFILE" label on the left, chevron button on the right.
class _TopRow extends StatelessWidget {
  const _TopRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Label
        Text(
          'MEMBER PROFILE',
          style: AppUrbanist.body(
            color: Colors.white.withValues(alpha: 0.75),
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
          ).copyWith(letterSpacing: 11.sp * 0.08),
        ),

        const Spacer(),

        // Chevron in rounded square
        Container(
          width: 30.r,
          height: 30.r,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(10.r),
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.chevron_right_rounded,
            color: Colors.white,
            size: 16.sp,
          ),
        ),
      ],
    );
  }
}

/// Main row: 62×62 rounded-square avatar + name / email column.
class _MainRow extends StatelessWidget {
  final String initial;
  final String fullName;
  final String email;

  const _MainRow({
    required this.initial,
    required this.fullName,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar
        Container(
          width: 62.r,
          height: 62.r,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(18.r),
          ),
          alignment: Alignment.center,
          child: Text(
            initial,
            style: AppUrbanist.body(
              color: Colors.white,
              fontSize: 26.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        SizedBox(width: 14.w),

        // Name + email
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                fullName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppUrbanist.body(
                  color: Colors.white,
                  fontSize: 19.sp,
                  fontWeight: FontWeight.w800,
                ).copyWith(letterSpacing: 19.sp * -0.01),
              ),
              SizedBox(height: 2.h),
              Text(
                email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppUrbanist.body(
                  color: Colors.white.withValues(alpha: 0.80),
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Bottom row: "HABITFLOW ID" label on the left, formatted ID on the right.
class _BottomRow extends StatelessWidget {
  final String habitflowId;

  const _BottomRow({required this.habitflowId});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'HABITFLOW ID',
          style: AppUrbanist.body(
            color: Colors.white.withValues(alpha: 0.60),
            fontSize: 10.5.sp,
            fontWeight: FontWeight.w700,
          ).copyWith(letterSpacing: 10.5.sp * 0.07),
        ),

        const Spacer(),

        // Flexible prevents overflow on very narrow screens
        Flexible(
          child: Text(
            habitflowId,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: AppUrbanist.body(
              color: Colors.white.withValues(alpha: 0.92),
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w700,
            ).copyWith(letterSpacing: 12.5.sp * 0.14),
          ),
        ),
      ],
    );
  }
}

/// A dashed horizontal line painted via [CustomPainter].
///
/// Renders 5px dashes with 3px gaps, 1.5px stroke, white at 30% opacity.
class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1.5,
      child: CustomPaint(
        painter: _DashedLinePainter(),
        size: Size(double.infinity, 1.5),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.30)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashGap = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset((startX + dashWidth).clamp(0, size.width), 0),
        paint,
      );
      startX += dashWidth + dashGap;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter oldDelegate) => false;
}

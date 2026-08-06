import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';

class ProgressCard extends StatelessWidget {
  final int completedHabits;
  final int totalHabits;
  final List<bool> weekProgress;
  final int currentStreak;

  const ProgressCard({
    super.key,
    required this.completedHabits,
    required this.totalHabits,
    required this.weekProgress,
    required this.currentStreak,
  });

  @override
  Widget build(BuildContext context) {
    final progress =
        totalHabits == 0 ? 0.0 : completedHabits / totalHabits;
    final pct = (progress * 100).toInt();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: section title
          Text(
            "Today's Progress",
            style: AppTextStyles.title.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 16.sp,
            ),
          ),

          SizedBox(height: 14.h),

          // Week dots row
          _buildWeekProgress(),

          SizedBox(height: 14.h),

          // Progress bar section inside subtle container
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 12.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$completedHabits of $totalHabits habits done",
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                            fontSize: 13.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutCubic,
                      tween: Tween<double>(begin: 0, end: pct.toDouble()),
                      builder: (context, value, child) {
                        return Text(
                          "${value.toInt()}%",
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w700,
                                fontSize: 13.sp,
                            color: AppColors.primary,
                          ),
                        );
                      },
                    ),
                  ],
                ),

                SizedBox(height: 10.h),

                // Animated progress bar
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                  tween: Tween<double>(begin: 0, end: progress),
                  builder: (context, animatedValue, child) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      child: LinearProgressIndicator(
                        value: animatedValue,
                        minHeight: 10.h,
                        backgroundColor:
                            AppColors.primaryLight.withValues(alpha: 0.4),
                        valueColor:
                            const AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 14.h),

          // Bottom stat row
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  icon: Icons.local_fire_department_rounded,
                  iconColor: const Color(0xFFFF6B35),
                  value: "$currentStreak",
                  label: "day streak",
                ),
              ),
              Container(width: 1, height: 24.h, color: AppColors.divider),
              Expanded(
                child: _StatTile(
                  icon: Icons.check_circle_rounded,
                  iconColor: AppColors.primary,
                  value: "$completedHabits/$totalHabits",
                  label: "completed",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekProgress() {
    const labels = ["M", "T", "W", "T", "F", "S", "S"];
    final todayIndex = DateTime.now().weekday - 1;

    return Row(
      children: List.generate(7, (index) {
        return Expanded(
          child: _buildDayDot(
            labels[index],
            completed: weekProgress[index],
            isToday: index == todayIndex,
            isUpcoming: index > todayIndex,
          ),
        );
      }),
    );
  }

  Widget _buildDayDot(
    String day, {
    required bool completed,
    required bool isToday,
    required bool isUpcoming,
  }) {
    const double size = 26;

    final Color bgColor;
    final Color dayLabelColor;
    Widget? dotChild;

    if (isToday || completed) {
      bgColor = AppColors.primary;
      dayLabelColor = isToday ? AppColors.primary : AppColors.textSecondary;
      dotChild = Center(
        child: Icon(
          Icons.check_rounded,
          color: Colors.white,
          size: 13.sp,
        ),
      );
    } else if (isUpcoming) {
      bgColor = Colors.transparent;
      dayLabelColor = AppColors.textSecondary;
      dotChild = null;
    } else {
      bgColor = AppColors.primaryLight.withValues(alpha: 0.3);
      dayLabelColor = AppColors.textMuted.withValues(alpha: 0.45);
      dotChild = null;
    }

    Widget dot = AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        boxShadow: isToday
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: completed || isToday ? 1.0 : 0.0,
        child: dotChild,
      ),
    );

    if (isUpcoming) {
      dot = CustomPaint(
        painter: _DashedCirclePainter(
          color: AppColors.border.withValues(alpha: 0.55),
          strokeWidth: 1.4,
          dashWidth: 3.5,
          dashGap: 2.5,
        ),
        child: dot,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          day,
          style: AppTextStyles.caption.copyWith(
            fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
            color: dayLabelColor,
            fontSize: 12.sp,
          ),
        ),
        SizedBox(height: 4.h),
        dot,
      ],
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  const _DashedCirclePainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashGap,
  });

  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashGap;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) / 2) - strokeWidth / 2;
    final circumference = 2 * math.pi * radius;

    final totalDash = dashWidth + dashGap;
    final dashCount = (circumference / totalDash).floor();
    final dashAngle = (dashWidth / circumference) * 2 * math.pi;
    final gapAngle = (2 * math.pi / dashCount) - dashAngle;

    double angle = -math.pi / 2;

    for (int i = 0; i < dashCount; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        angle,
        dashAngle,
        false,
        paint,
      );
      angle += dashAngle + gapAngle;
    }
  }

  @override
  bool shouldRepaint(_DashedCirclePainter old) =>
      old.color != color ||
      old.strokeWidth != strokeWidth ||
      old.dashWidth != dashWidth ||
      old.dashGap != dashGap;
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 28.w,
          height: 28.w,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(icon, color: iconColor, size: 14.sp),
        ),
        SizedBox(width: 6.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: AppTextStyles.title.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 14.sp,
                color: AppColors.textPrimary,
                height: 1.1,
              ),
            ),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textMuted,
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

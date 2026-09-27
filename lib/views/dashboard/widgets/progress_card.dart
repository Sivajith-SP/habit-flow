import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_flow_tokens.dart';
import '../../../app/theme/app_radius.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({
    super.key,
    required this.completedHabits,
    required this.totalHabits,
    required this.weekProgress,
  });

  final int completedHabits;
  final int totalHabits;
  final List<bool> weekProgress;

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final double targetProgress = totalHabits == 0 ? 0.0 : (completedHabits / totalHabits).clamp(0.0, 1.0);
    final int remaining = (totalHabits - completedHabits).clamp(0, totalHabits);
    final bool disableAnimations = MediaQuery.of(context).disableAnimations;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: tokens.tileLavender,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: isDark ? null : tokens.cardShadow,
        border: isDark ? Border.all(color: tokens.border, width: 1) : null,
      ),
      child: Column(
        children: [
          // Top Row: Circular Ring on Left + Stats & Chip on Right
          Row(
            children: [
              // Left: 104px circular progress ring
              SizedBox(
                width: 104.r,
                height: 104.r,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(
                    begin: 0.0,
                    end: targetProgress,
                  ),
                  duration: disableAnimations
                      ? Duration.zero
                      : const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  builder: (context, animValue, _) {
                    final currentPercentage = (animValue * 100).toInt();

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          size: Size(104.r, 104.r),
                          painter: _CircularProgressPainter(
                            progress: animValue,
                            trackColor: Colors.white.withValues(
                              alpha: isDark ? 0.18 : 0.45,
                            ),
                            progressColor: tokens.accent,
                            strokeWidth: 11.w,
                          ),
                        ),
                        Text(
                          '$currentPercentage%',
                          style: AppUrbanist.percentage(color: tokens.text),
                        ),
                      ],
                    );
                  },
                ),
              ),

              SizedBox(width: 18.w),

              // Right: Title, Subtitle, Remaining Chip
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today's progress",
                      style: AppUrbanist.sectionTitle(color: tokens.text),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '$completedHabits of $totalHabits habits done',
                      style: AppUrbanist.body(
                        color: tokens.text.withValues(alpha: 0.75),
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    // Chip: "{n} left today" or "Nothing left"
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: tokens.raised,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: isDark ? null : [
                          BoxShadow(
                            color: tokens.tileLavenderIcon.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        remaining == 0 ? 'Nothing left' : '$remaining left today',
                        style: AppUrbanist.body(
                          color: tokens.text,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 18.h),

          // Bottom: Week strip in translucent chip-colored rounded container
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: tokens.raised.withValues(alpha: isDark ? 0.35 : 0.55),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: _WeekStrip(weekProgress: weekProgress),
          ),
        ],
      ),
    );
  }
}

class _WeekStrip extends StatelessWidget {
  const _WeekStrip({required this.weekProgress});

  final List<bool> weekProgress;

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    // 0 = Monday, 6 = Sunday
    final todayWeekday = DateTime.now().weekday - 1;

    return Row(
      children: List.generate(7, (index) {
        final bool isPast = index < todayWeekday;
        final bool isToday = index == todayWeekday;
        final bool isFuture = index > todayWeekday;
        final bool isCompleted = index < weekProgress.length && weekProgress[index];

        return Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                labels[index],
                style: AppUrbanist.body(
                  color: isToday ? tokens.text : tokens.mutedText,
                  fontSize: 13.sp,
                  fontWeight: isToday ? FontWeight.w800 : FontWeight.w700,
                ),
              ),
              SizedBox(height: 6.h),
              _buildDayDot(
                tokens: tokens,
                isPast: isPast,
                isToday: isToday,
                isFuture: isFuture,
                isCompleted: isCompleted,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDayDot({
    required HabitFlowTokens tokens,
    required bool isPast,
    required bool isToday,
    required bool isFuture,
    required bool isCompleted,
  }) {
    // 30px circle
    final double size = 30.r;

    if (isToday) {
      // Today: Outer accent outline ring
      return Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: tokens.accent, width: 2),
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted ? tokens.accent : Colors.transparent,
          ),
          child: isCompleted
              ? Icon(
                  Icons.check_rounded,
                  color: tokens.onAccent,
                  size: 15.sp,
                )
              : null,
        ),
      );
    }

    if (isCompleted) {
      // Completed past day: filled accent with white check
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: tokens.accent,
        ),
        child: Center(
          child: Icon(
            Icons.check_rounded,
            color: tokens.onAccent,
            size: 16.sp,
          ),
        ),
      );
    }

    if (isPast) {
      // Missed past day: faint neutral circle
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: tokens.text.withValues(alpha: 0.12),
        ),
      );
    }

    // Future day: empty faint circle
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: tokens.text.withValues(alpha: 0.08),
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, trackPaint);

    if (progress > 0.0) {
      final progressPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = strokeWidth;

      const startAngle = -math.pi / 2;
      final sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.progressColor != progressColor ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.strokeWidth != strokeWidth;
}

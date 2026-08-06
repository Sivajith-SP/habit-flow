import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';

class WeekCalendar extends StatelessWidget {
  const WeekCalendar({super.key});

  List<DateTime> _currentWeekDays() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (i) => monday.add(Duration(days: i)));
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _monthLabel(DateTime first, DateTime last) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
    ];
    return first.month == last.month
        ? months[first.month - 1]
        : "${months[first.month - 1]} – ${months[last.month - 1]}";
  }

  @override
  Widget build(BuildContext context) {
    const dayLabels = ["M", "T", "W", "T", "F", "S", "S"];
    final today = DateTime.now();
    final weekDays = _currentWeekDays();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "This Week",
                style: AppTextStyles.title.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                ),
              ),
              Text(
                _monthLabel(weekDays.first, weekDays.last),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: AppSpacing.md),

        // Day chips
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final day = weekDays[index];
            final isToday = _isSameDay(day, today);
            final isPast = day.isBefore(
              DateTime(today.year, today.month, today.day),
            );

            return _DayChip(
              label: dayLabels[index],
              dateNum: day.day.toString(),
              isToday: isToday,
              isPast: isPast,
            );
          }),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Day chip — today solid, past faded, upcoming dashed border
// ─────────────────────────────────────────────────────────────

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.label,
    required this.dateNum,
    required this.isToday,
    required this.isPast,
  });

  final String label;
  final String dateNum;
  final bool isToday;
  final bool isPast;

  @override
  Widget build(BuildContext context) {
    // ── colours per state ──
    final Color chipBg = isToday
        ? AppColors.primary
        : Colors.transparent;

    final Color labelColor = isToday
        ? Colors.white.withValues(alpha: 0.8)
        : isPast
            ? AppColors.textMuted.withValues(alpha: 0.5)
            : AppColors.textSecondary;

    final Color numColor = isToday
        ? Colors.white
        : isPast
            ? AppColors.textSecondary.withValues(alpha: 0.45)
            : AppColors.textPrimary;

    const double chipW = 40;
    const double chipH = 72;

    Widget chip = AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: chipW.w,
      height: chipH.h,
      decoration: BoxDecoration(
        color: chipBg,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: isToday
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: labelColor,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            dateNum,
            style: AppTextStyles.title.copyWith(
              color: numColor,
              fontSize: 15.sp,
              fontWeight: isToday ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    // Wrap upcoming days with dashed border painter
    if (!isToday && !isPast) {
      chip = CustomPaint(
        painter: _DashedRoundedBorderPainter(
          color: AppColors.border.withValues(alpha: 0.6),
          radius: AppRadius.lg,
          dashWidth: 4,
          dashGap: 3,
          strokeWidth: 1.5,
        ),
        child: chip,
      );
    }

    return chip;
  }
}

// ─────────────────────────────────────────────────────────────
// CustomPainter — dashed rounded rectangle border
// ─────────────────────────────────────────────────────────────

class _DashedRoundedBorderPainter extends CustomPainter {
  const _DashedRoundedBorderPainter({
    required this.color,
    required this.radius,
    required this.dashWidth,
    required this.dashGap,
    required this.strokeWidth,
  });

  final Color color;
  final double radius;
  final double dashWidth;
  final double dashGap;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    final totalLength = _pathLength(path);
    final dashArray = dashWidth + dashGap;
    final dashCount = (totalLength / dashArray).floor();

    final metrics = path.computeMetrics().toList();
    int dashIndex = 0;

    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final remaining = metric.length - distance;
        final currentDash = math.min(dashWidth, remaining);
        canvas.drawPath(
          metric.extractPath(distance, distance + currentDash),
          paint,
        );
        distance += currentDash + dashGap;
        dashIndex++;
        if (dashIndex >= dashCount * 2) break;
      }
    }
  }

  double _pathLength(Path path) {
    return path
        .computeMetrics()
        .fold(0.0, (sum, m) => sum + m.length);
  }

  @override
  bool shouldRepaint(_DashedRoundedBorderPainter old) =>
      old.color != color ||
      old.radius != radius ||
      old.dashWidth != dashWidth ||
      old.dashGap != dashGap ||
      old.strokeWidth != strokeWidth;
}

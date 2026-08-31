import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';

class WeekCalendar extends StatelessWidget {
  const WeekCalendar({super.key});

  List<DateTime> _currentWeekDays() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));

    return List.generate(
      7,
          (i) => monday.add(Duration(days: i)),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year &&
          a.month == b.month &&
          a.day == b.day;

  String _monthLabel(DateTime first, DateTime last) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    return first.month == last.month
        ? months[first.month - 1]
        : "${months[first.month - 1]} – ${months[last.month - 1]}";
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    const dayLabels = ["M", "T", "W", "T", "F", "S", "S"];

    final today = DateTime.now();
    final weekDays = _currentWeekDays();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "This Week",
                style: AppTextStyles.title.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                ),
              ),
              Text(
                _monthLabel(
                  weekDays.first,
                  weekDays.last,
                ),
                style: AppTextStyles.caption.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: AppSpacing.md),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final day = weekDays[index];

            final isToday = _isSameDay(day, today);

            final isPast = day.isBefore(
              DateTime(
                today.year,
                today.month,
                today.day,
              ),
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
    final colorScheme = Theme.of(context).colorScheme;

    final chipBg = isToday
        ? colorScheme.primary
        : Colors.transparent;

    final labelColor = isToday
        ? colorScheme.onPrimary.withValues(alpha: 0.8)
        : isPast
        ? colorScheme.onSurfaceVariant.withValues(alpha: 0.5)
        : colorScheme.onSurfaceVariant;

    final numColor = isToday
        ? colorScheme.onPrimary
        : isPast
        ? colorScheme.onSurface.withValues(alpha: 0.45)
        : colorScheme.onSurface;

    const chipW = 40.0;
    const chipH = 72.0;

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
            color: colorScheme.primary.withValues(
              alpha: 0.3,
            ),
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
              fontWeight: isToday
                  ? FontWeight.w800
                  : FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (!isToday && !isPast) {
      chip = CustomPaint(
        painter: _DashedRoundedBorderPainter(
          color: colorScheme.outline.withValues(alpha: 0.6),
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

    final metrics = path.computeMetrics().toList();

    for (final metric in metrics) {
      double distance = 0;

      while (distance < metric.length) {
        final remaining = metric.length - distance;
        final currentDash = math.min(dashWidth, remaining);

        canvas.drawPath(
          metric.extractPath(
            distance,
            distance + currentDash,
          ),
          paint,
        );

        distance += currentDash + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(
      _DashedRoundedBorderPainter old,
      ) {
    return old.color != color ||
        old.radius != radius ||
        old.dashWidth != dashWidth ||
        old.dashGap != dashGap ||
        old.strokeWidth != strokeWidth;
  }
}
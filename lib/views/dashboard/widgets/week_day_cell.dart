import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme/app_flow_tokens.dart';

/// A single day column in the week indicator strip.
class WeekDayCell extends StatelessWidget {
  final DateTime date;
  final bool isToday;
  final bool isSelected;
  final bool isFuture;

  /// Fraction of habits done for this day (0.0 – 1.0).
  final double completionFraction;

  /// Whether ALL habits for this day are done.
  final bool allDone;

  /// Number of habits completed on this day.
  final int doneCount;

  /// Total habits scheduled for this day.
  final int totalCount;

  final VoidCallback? onTap;

  const WeekDayCell({
    super.key,
    required this.date,
    required this.isToday,
    required this.isSelected,
    required this.isFuture,
    required this.completionFraction,
    required this.allDone,
    required this.doneCount,
    required this.totalCount,
    this.onTap,
  });

  static const _dayLetters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  static const _weekdayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 0 = Monday, 6 = Sunday
    final weekdayIndex = date.weekday - 1;
    final dayLetter = _dayLetters[weekdayIndex];
    final semanticWeekday = _weekdayNames[weekdayIndex];
    final semanticDate = '${date.month}/${date.day}';

    final dayLetterColor = isToday
        ? tokens.accent
        : tokens.text.withValues(alpha: 0.60);
    final dayLetterWeight = isToday ? FontWeight.w800 : FontWeight.w700;

    final selectedBg = isDark
        ? Colors.white.withValues(alpha: 0.14)
        : Colors.white;
    final selectedShadow = isDark
        ? <BoxShadow>[]
        : [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ];

    return Semantics(
      label: '$semanticWeekday $semanticDate, $doneCount of $totalCount done',
      selected: isSelected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : Colors.transparent,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: isSelected ? selectedShadow : [],
        ),
        child: InkWell(
          onTap: isFuture ? null : onTap,
          borderRadius: BorderRadius.circular(18.r),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 44.r, minWidth: 44.r),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Opacity(
                opacity: isFuture ? 0.40 : 1.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      dayLetter,
                      style: GoogleFonts.urbanist(
                        fontSize: 12.sp,
                        fontWeight: dayLetterWeight,
                        color: dayLetterColor,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    _DayDot(
                      date: date,
                      isToday: isToday,
                      allDone: allDone,
                      completionFraction: completionFraction,
                      tokens: tokens,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DayDot extends StatelessWidget {
  final DateTime date;
  final bool isToday;
  final bool allDone;
  final double completionFraction;
  final HabitFlowTokens tokens;

  const _DayDot({
    required this.date,
    required this.isToday,
    required this.allDone,
    required this.completionFraction,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    final double size = 30.r;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final trackColor = Colors.white.withValues(alpha: isDark ? 0.18 : 0.45);

    if (allDone) {
      if (isToday) {
        // Filled accent circle with 2px accent outline ring and 2px gap
        return Container(
          width: size + 6,
          height: size + 6,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: tokens.accent, width: 2),
          ),
          child: Container(
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
          ),
        );
      } else {
        // Filled accent circle with check
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
    }

    // Partly done or nothing done: draw partial/empty ring
    return SizedBox(
      width: isToday ? size + 6 : size,
      height: isToday ? size + 6 : size,
      child: CustomPaint(
        painter: _PartialRingPainter(
          fraction: completionFraction,
          trackColor: trackColor,
          accentColor: tokens.accent,
          strokeWidth: 3.5,
          isToday: isToday,
          todayBorderColor: tokens.accent,
        ),
        child: Center(
          child: Text(
            '${date.day}',
            style: GoogleFonts.urbanist(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: tokens.text,
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}

class _PartialRingPainter extends CustomPainter {
  final double fraction;
  final Color trackColor;
  final Color accentColor;
  final double strokeWidth;
  final bool isToday;
  final Color todayBorderColor;

  const _PartialRingPainter({
    required this.fraction,
    required this.trackColor,
    required this.accentColor,
    required this.strokeWidth,
    required this.isToday,
    required this.todayBorderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Track
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    // Accent arc for partial completion
    if (fraction > 0.0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * fraction.clamp(0.0, 1.0),
        false,
        Paint()
          ..color = accentColor
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = strokeWidth,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PartialRingPainter old) =>
      old.fraction != fraction ||
      old.trackColor != trackColor ||
      old.accentColor != accentColor ||
      old.strokeWidth != strokeWidth ||
      old.isToday != isToday;
}

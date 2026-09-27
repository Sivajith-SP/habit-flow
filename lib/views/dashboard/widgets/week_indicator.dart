import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_flow_tokens.dart';
import 'week_day_cell.dart';

/// Per-day data passed into [WeekIndicator].
class WeekDayData {
  final DateTime date;
  final int doneCount;
  final int totalCount;

  const WeekDayData({
    required this.date,
    required this.doneCount,
    required this.totalCount,
  });

  double get fraction =>
      totalCount == 0 ? 0.0 : (doneCount / totalCount).clamp(0.0, 1.0);

  bool get allDone => totalCount > 0 && doneCount >= totalCount;
}

/// 7-column interactive week strip.
class WeekIndicator extends StatelessWidget {
  /// One entry per day Mon–Sun. Must have exactly 7 items.
  final List<WeekDayData> days;

  final DateTime selectedDate;
  final DateTime today;

  final ValueChanged<DateTime> onDayTap;

  const WeekIndicator({
    super.key,
    required this.days,
    required this.selectedDate,
    required this.today,
    required this.onDayTap,
  });

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor =
        tokens.raised.withValues(alpha: isDark ? 0.30 : 0.55);

    return Container(
      padding: EdgeInsets.all(6.r),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Row(
        children: List.generate(days.length, (i) {
          final data = days[i];
          final isToday = _isSameDay(data.date, today);
          final isSelected = _isSameDay(data.date, selectedDate);
          final isFuture = data.date.isAfter(
            DateTime(today.year, today.month, today.day),
          );

          return Expanded(
            child: WeekDayCell(
              date: data.date,
              isToday: isToday,
              isSelected: isSelected,
              isFuture: isFuture,
              completionFraction: data.fraction,
              allDone: data.allDone,
              doneCount: data.doneCount,
              totalCount: data.totalCount,
              onTap: () => onDayTap(data.date),
            ),
          );
        }),
      ),
    );
  }
}

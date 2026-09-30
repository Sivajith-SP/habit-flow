import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_flow_tokens.dart';

/// Weekly activity card with an animated fl_chart BarChart.
class WeeklyProgressCard extends StatelessWidget {
  final List<bool> weeklyProgress;

  const WeeklyProgressCard({super.key, required this.weeklyProgress});

  static const _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // today's weekday index: Monday=0 … Sunday=6
    final todayIdx = DateTime.now().weekday - 1;

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: isDark ? Border.all(color: tokens.border, width: 1) : null,
        boxShadow: isDark ? null : tokens.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Weekly Activity',
            style: AppUrbanist.body(
              color: tokens.text,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Your completion this week',
            style: AppUrbanist.body(color: tokens.mutedText, fontSize: 13),
          ),
          SizedBox(height: 20.h),

          // Bar chart
          SizedBox(
            height: 160.h,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 1.0,
                minY: 0,
                barGroups: List.generate(
                  _dayLabels.length,
                  (i) {
                    final isCompleted =
                        i < weeklyProgress.length && weeklyProgress[i];
                    final isToday = i == todayIdx;
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: isCompleted ? 1.0 : 0.28,
                          color: isCompleted
                              ? tokens.accent
                              : tokens.field,
                          width: 28.w,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(7),
                          ),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: 1.0,
                            color: isToday
                                ? tokens.accent.withValues(alpha: 0.10)
                                : Colors.transparent,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28.h,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i < 0 || i >= _dayLabels.length) {
                          return const SizedBox.shrink();
                        }
                        final isToday = i == todayIdx;
                        return Padding(
                          padding: EdgeInsets.only(top: 6.h),
                          child: Text(
                            _dayLabels[i],
                            style: AppUrbanist.body(
                              color: isToday
                                  ? tokens.accent
                                  : tokens.mutedText,
                              fontSize: 12,
                              fontWeight: isToday
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_flow_tokens.dart';

/// Weekly activity card — reference-image redesign.
/// White surface card, pill-shaped bars (fully rounded), completed bars in
/// pink/magenta, today highlighted in accent purple, inactive bars grey.
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

    // Colours matching the reference image
    final completedColor = tokens.tilePinkIcon; // pink/magenta
    final todayColor = tokens.accent;           // accent purple
    final inactiveColor = tokens.field;         // light grey

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
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
            'Weekly activity',
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

                    // The front rod is always full height (1.0) with the grey
                    // pill as the background. For completed/today days the
                    // coloured fill stacks on top via a rod stack, simulating
                    // the "water in a glass" look.
                    Color fillColor;
                    double fillLevel;
                    if (isCompleted) {
                      fillColor = completedColor;
                      fillLevel = 1.0;
                    } else if (isToday) {
                      fillColor = todayColor;
                      fillLevel = 1.0;
                    } else {
                      // No fill — transparent front rod, grey bg shows
                      fillColor = Colors.transparent;
                      fillLevel = 1.0;
                    }

                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          // Front rod = colored fill (or transparent)
                          toY: fillLevel,
                          color: fillColor,
                          width: 26.w,
                          borderRadius: BorderRadius.circular(13.r),
                          // Background rod = always full-height grey pill
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: 1.0,
                            color: inactiveColor,
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
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24.h,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i < 0 || i >= _dayLabels.length) {
                          return const SizedBox.shrink();
                        }
                        final isCompleted =
                            i < weeklyProgress.length && weeklyProgress[i];
                        final isToday = i == todayIdx;
                        // Show "1" above completed or today bars like in ref
                        if (isCompleted || isToday) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 4.h),
                            child: Text(
                              '1',
                              style: AppUrbanist.body(
                                color: isCompleted
                                    ? completedColor
                                    : tokens.accent,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_flow_tokens.dart';

/// Three floating KPI tiles: Completion %, Completed Today, Streak.
class StatisticsOverviewCard extends StatelessWidget {
  final int completedToday;
  final int totalHabits;
  final int currentStreak;

  const StatisticsOverviewCard({
    super.key,
    required this.completedToday,
    required this.totalHabits,
    required this.currentStreak,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;

    final pct = totalHabits == 0
        ? 0
        : ((completedToday / totalHabits) * 100).round();

    return Row(
      children: [
        Expanded(
          child: _KpiTile(
            value: '$pct%',
            label: 'Completion',
            bg: tokens.tileLavender,
            valueColor: tokens.tileLavenderIcon,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _KpiTile(
            value: '$completedToday',
            label: 'Completed',
            bg: tokens.tileMint,
            valueColor: tokens.tileMintIcon,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _KpiTile(
            value: '🔥 $currentStreak',
            label: 'Streak',
            bg: tokens.tileButter,
            valueColor: tokens.tileButterIcon,
          ),
        ),
      ],
    );
  }
}

class _KpiTile extends StatelessWidget {
  final String value;
  final String label;
  final Color bg;
  final Color valueColor;

  const _KpiTile({
    required this.value,
    required this.label,
    required this.bg,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88.h,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: AppUrbanist.body(
              color: valueColor,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: AppUrbanist.body(
              color: valueColor.withValues(alpha: 0.75),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

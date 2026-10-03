import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_flow_tokens.dart';

/// Two-tile overview row — Completion % and Completed count.
/// Matches the reference image layout: label on top, large value below,
/// icon in the top-right corner.
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
        // Completion % — mint green
        Expanded(
          child: _OverviewTile(
            label: 'Completion',
            value: '$pct%',
            bg: tokens.tileMint,
            valueColor: tokens.tileMintIcon,
            icon: Icons.check_circle_outline_rounded,
          ),
        ),
        SizedBox(width: 12.w),
        // Completed today — butter yellow
        Expanded(
          child: _OverviewTile(
            label: 'Completed',
            value: '$completedToday',
            bg: tokens.tileButter,
            valueColor: tokens.tileButterIcon,
            icon: Icons.check_rounded,
          ),
        ),
      ],
    );
  }
}

class _OverviewTile extends StatelessWidget {
  final String label;
  final String value;
  final Color bg;
  final Color valueColor;
  final IconData icon;

  const _OverviewTile({
    required this.label,
    required this.value,
    required this.bg,
    required this.valueColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96.h,
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label row with icon
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                style: AppUrbanist.body(
                  color: valueColor.withValues(alpha: 0.80),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              // Circle icon badge
              Container(
                width: 26.r,
                height: 26.r,
                decoration: BoxDecoration(
                  color: valueColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: valueColor,
                  size: 15.sp,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Large value
          Text(
            value,
            style: AppUrbanist.body(
              color: valueColor,
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_flow_tokens.dart';

/// Two-tile overview row — Today's Rate % and Done Today count.
/// Height is intrinsic (no fixed height) so it scales on all screen sizes.
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

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Today's Rate % — mint green
          Expanded(
            child: _OverviewTile(
              label: "Today's Rate",
              value: '$pct%',
              subtitle: '$completedToday of $totalHabits habits',
              bg: tokens.tileMint,
              valueColor: tokens.tileMintIcon,
              icon: Icons.check_circle_outline_rounded,
            ),
          ),
          SizedBox(width: 12.w),
          // Done Today count — butter yellow
          Expanded(
            child: _OverviewTile(
              label: 'Done Today',
              value: '$completedToday',
              subtitle: totalHabits == 0 ? 'no habits scheduled' : 'habits finished',
              bg: tokens.tileButter,
              valueColor: tokens.tileButterIcon,
              icon: Icons.check_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewTile extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final Color bg;
  final Color valueColor;
  final IconData icon;

  const _OverviewTile({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.bg,
    required this.valueColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // No fixed height — intrinsic sizing lets content breathe on all screens
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label row with icon
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Flexible prevents the label from overflowing the row
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppUrbanist.body(
                    color: valueColor.withValues(alpha: 0.80),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 6.w),
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
          SizedBox(height: 10.h),
          // Large value
          Text(
            value,
            style: AppUrbanist.body(
              color: valueColor,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 2.h),
          // Subtitle clarifier
          Text(
            subtitle,
            style: AppUrbanist.body(
              color: valueColor.withValues(alpha: 0.60),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

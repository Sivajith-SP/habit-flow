import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';

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
    final completionPercentage = totalHabits == 0
        ? 0
        : ((completedToday / totalHabits) * 100).round();

    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Overview', style: AppTextStyles.title),

          SizedBox(height: AppSpacing.lg),

          Row(
            children: [
              Expanded(
                child: _StatItem(
                  value: '$completionPercentage%',
                  label: 'Completion',
                ),
              ),
              Expanded(
                child: _StatItem(value: '$completedToday', label: 'Completed'),
              ),
              Expanded(
                child: _StatItem(value: '$currentStreak', label: 'Streak'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.primary,
            fontSize: 24.sp,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

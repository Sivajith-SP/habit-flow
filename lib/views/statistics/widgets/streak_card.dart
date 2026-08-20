import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';

class StreakCard extends StatelessWidget {
  final int currentStreak;
  const StreakCard({super.key, required this.currentStreak,});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        children: [
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(
              Icons.local_fire_department_rounded,
              color: AppColors.primary,
              size: 28.sp,
            ),
          ),

          SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Streak',
                  style: AppTextStyles.title,
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'Keep building your consistency',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),

          Text(
            '$currentStreak ${currentStreak == 1 ? 'day' : 'days'}',
            style: AppTextStyles.heading2.copyWith(
              color: AppColors.primary,
              fontSize: 20.sp,
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';

class MonthlyProgressCard extends StatelessWidget {
  final int monthlyCompleted;
  final int monthlyTotal;

  const MonthlyProgressCard({
    super.key,
    required this.monthlyCompleted,
    required this.monthlyTotal,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = monthlyTotal == 0
        ? 0
        : ((monthlyCompleted / monthlyTotal) * 100).round();
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
          Text('Monthly Progress', style: AppTextStyles.title),

          SizedBox(height: AppSpacing.xs),

          Text(
            'Your overall consistency this month',
            style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
          ),

          SizedBox(height: AppSpacing.lg),

          Row(
            children: [
              SizedBox(
                width: 82.w,
                height: 82.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 82.w,
                      height: 82.w,
                      child: CircularProgressIndicator(
                        value: 0.65,
                        strokeWidth: 8.w,
                        backgroundColor: AppColors.primaryLight.withValues(
                          alpha: 0.35,
                        ),
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      '$percentage%',
                      style: AppTextStyles.title.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: AppSpacing.lg),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Great progress!', style: AppTextStyles.title),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      'Keep completing your habits to improve your consistency.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

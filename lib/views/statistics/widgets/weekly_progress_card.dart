import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';

class WeeklyProgressCard extends StatelessWidget {
  final List<bool> weeklyProgress;

  const WeeklyProgressCard({super.key, required this.weeklyProgress});

  static const _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
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
          Text('Weekly Progress', style: AppTextStyles.title),

          SizedBox(height: AppSpacing.xs),

          Text(
            'Your completion this week',
            style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
          ),

          SizedBox(height: AppSpacing.lg),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_days.length, (index) {
              final isCompleted =
                  index < weeklyProgress.length && weeklyProgress[index];
              return Column(
                children: [
                  Text(
                    _days[index],
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: AppSpacing.sm),

                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppColors.primary
                          : AppColors.primaryLight.withValues(alpha: 0.45),
                      shape: BoxShape.circle,
                    ),
                    child: isCompleted
                        ? Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 18.sp,
                          )
                        : null,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

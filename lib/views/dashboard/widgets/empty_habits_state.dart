import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';

class EmptyHabitsState extends StatelessWidget {
  const EmptyHabitsState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xl,
      ),
      // decoration: BoxDecoration(
      //   color: AppColors.card,
      //   borderRadius: BorderRadius.circular(AppRadius.xl),
      //   boxShadow: AppShadows.soft,
      // ),
      child: Column(
        children: [
          Container(
            width: 72.w,
            height: 72.w,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.task_alt_rounded,
              color: AppColors.primary,
              size: 36.sp,
            ),
          ),

          SizedBox(height: AppSpacing.lg),

          Text(
            "No habits for today",
            style: AppTextStyles.heading2.copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: AppSpacing.sm),

          Text(
            "Tap the + button to create your first habit and start building consistency.",
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

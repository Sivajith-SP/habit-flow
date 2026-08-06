import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_spacing.dart';

class HabitsLoadingState extends StatelessWidget {
  const HabitsLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _SkeletonHabitCard(),
        _SkeletonHabitCard(),
        _SkeletonHabitCard(),
      ],
    );
  }
}

class _SkeletonHabitCard extends StatelessWidget {
  const _SkeletonHabitCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        children: [
          // Status Circle
          Container(
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryLight.withValues(alpha: .5),
            ),
          ),

          SizedBox(width: AppSpacing.md),

          // Title + Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonBar(width: 140.w, height: 16.h),

                SizedBox(height: AppSpacing.sm),

                _SkeletonBar(width: 90.w, height: 12.h),
              ],
            ),
          ),

          SizedBox(width: AppSpacing.md),

          // Time
          _SkeletonBar(width: 56.w, height: 14.h),
        ],
      ),
    );
  }
}

class _SkeletonBar extends StatelessWidget {
  const _SkeletonBar({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: .45),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
    );
  }
}

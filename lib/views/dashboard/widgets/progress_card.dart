import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';

class ProgressCard extends StatelessWidget {
  final int completedHabits;
  final int totalHabits;
  final List<bool> weekProgress;
  final int currentStreak;


  const ProgressCard({
    super.key,
    required this.completedHabits,
    required this.totalHabits,
    required this.weekProgress,
    required this.currentStreak,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),

          SizedBox(height: AppSpacing.lg),

          // Week Progress
          _buildWeekProgress(),

          // Habit Progress
          SizedBox(height: AppSpacing.xl),

          _buildHabitProgress(),

          // Progress Bar
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.accentCream,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Row(
            children: [
              Text("🔥", style: TextStyle(fontSize: 16.sp)),
              SizedBox(width: 6.w),
              Text(
                "$currentStreak Day${currentStreak == 1 ? "" : "s"}",
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              )
            ],
          ),
        ),

        const Spacer(),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.track_changes_rounded,
                color: AppColors.primary,
                size: 16.sp,
              ),
              SizedBox(width: 6.w),
              Text(
                "$completedHabits/$totalHabits",
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeekProgress() {
    const labels = [
      "Mon",
      "Tue",
      "Wed",
      "Thu",
      "Fri",
      "Sat",
      "Sun",
    ];

    final todayIndex = DateTime.now().weekday - 1;

    return Row(
      children: List.generate(7, (index) {
        return Expanded(
          child: _buildDayIndicator(
            labels[index],
            completed: weekProgress[index],
            isToday: index == todayIndex,
          ),
        );
      }),
    );
  }

  Widget _buildDayIndicator(
    String day, {
    required bool completed,
    required bool isToday,
  }) {
    const double size = 32;

    Widget indicator;

    if (completed) {
      indicator = Container(
        width: size.w,
        height: size.w,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.check_rounded, color: Colors.white, size: 18.sp),
      );
    } else if (isToday) {
      indicator = Container(
        width: size.w,
        height: size.w,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 3),
        ),
      );
    } else {
      indicator = Container(
        width: size.w,
        height: size.w,
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          shape: BoxShape.circle,
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          day,
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),

        SizedBox(height: 12.h),

        indicator,
      ],
    );
  }

  Widget _buildHabitProgress() {
    final progress = totalHabits == 0
        ? 0.0
        : completedHabits / totalHabits;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "Today's Progress",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: AppTextStyles.title.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            SizedBox(width: AppSpacing.sm),

            Text(
              "${(progress * 100).toInt()}%",
              style: AppTextStyles.title.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        SizedBox(height: AppSpacing.xs),

        Text(
          "$completedHabits of $totalHabits habits completed",
          style: AppTextStyles.bodySmall,
        ),

        SizedBox(height: AppSpacing.md),

        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 12.h,
            backgroundColor: AppColors.primaryLight,
            valueColor: const AlwaysStoppedAnimation(
              AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

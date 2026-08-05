import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../models/habit/habit_frequency.dart';
import '../../../models/habit/habit_with_completion.dart';

class HabitCard extends StatelessWidget {
  final HabitWithCompletion habit;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onEdit;
  final bool isSelected;

  const HabitCard({
    super.key,
    required this.habit,
    this.onTap,
    this.onLongPress,
    this.onEdit,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          onTap: onTap,
          onLongPress: onLongPress,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 14.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
              boxShadow: AppShadows.soft,
            ),
            child: Row(
              children: [
                /// ICON
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    IconData(
                      habit.habit.iconCodePoint,
                      fontFamily: 'MaterialIcons',
                    ),
                    color: AppColors.primary,
                    size: 24.sp,
                  ),
                ),

                SizedBox(width: 14.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit.habit.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 15.sp,
                        ),
                      ),

                      SizedBox(height: 4.h),

                      Text(
                        habit.habit.description.isEmpty
                            ? "No description"
                            : habit.habit.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 10.w),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    _frequencyLabel(),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                SizedBox(width: 12.w),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: habit.isCompletedToday
                        ? AppColors.primary
                        : Colors.transparent,
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 200),
                    scale: habit.isCompletedToday ? 1 : 0,
                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        /// Floating Edit Button
        AnimatedPositioned(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          top: isSelected ? -10.h : 6.h,
          right: isSelected ? -8.w : 6.w,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 250),
            scale: isSelected ? 1 : 0,
            child: GestureDetector(
              onTap: onEdit,
              child: Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.soft,
                ),
                child: Icon(
                  Icons.edit_rounded,
                  color: Colors.white,
                  size: 16.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _frequencyLabel() {
    const dayLabels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

    switch (habit.habit.frequency) {
      case HabitFrequency.daily:
        return "Daily";
      case HabitFrequency.weekly:
        return "Weekly";
      case HabitFrequency.custom:
        final days = List<int>.from(habit.habit.targetDays)..sort();
        if (days.isEmpty) return "Custom";
        return days.map((d) => dayLabels[d]).join(", ");
    }
  }
}

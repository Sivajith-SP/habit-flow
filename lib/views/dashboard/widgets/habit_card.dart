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
    final bool done = habit.isCompletedToday;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          // Block all card-level interactions while in edit mode
          onTap: isSelected ? null : onTap,
          onLongPress: isSelected ? null : onLongPress,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 12.h,
            ),
            decoration: BoxDecoration(
              color: done
                  ? AppColors.primary.withValues(alpha: 0.06)
                  : AppColors.card,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : done
                        ? AppColors.primary.withValues(alpha: 0.2)
                        : AppColors.border.withValues(alpha: 0.5),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: done ? null : AppShadows.soft,
            ),
            child: Row(
              children: [
                // Habit Icon Container
                Container(
                  width: 42.w,
                  height: 42.w,
                  decoration: BoxDecoration(
                    color: done
                        ? AppColors.primary.withValues(alpha: 0.12)
                        : AppColors.primaryLight.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    IconData(
                      habit.habit.iconCodePoint,
                      fontFamily: 'MaterialIcons',
                    ),
                    color: done
                        ? AppColors.primary.withValues(alpha: 0.7)
                        : AppColors.primary,
                    size: 22.sp,
                  ),
                ),

                SizedBox(width: 12.w),

                // Title + Description Column
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
                          color: done
                              ? AppColors.textSecondary
                              : AppColors.textPrimary,
                          decoration: done
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationColor: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        habit.habit.description.isEmpty
                            ? _frequencyLabel()
                            : habit.habit.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 10.w),

                // Frequency Chip or Quick Edit Button depending on selection
                if (isSelected)
                  GestureDetector(
                    onTap: onEdit,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.edit_rounded,
                            color: Colors.white,
                            size: 13.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "Edit",
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 9.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      _frequencyLabel(),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
              ],
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

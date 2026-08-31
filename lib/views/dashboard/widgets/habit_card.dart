import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_shadows.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      onTap: isSelected ? null : onTap,
      onLongPress: isSelected ? null : onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: done
              ? colorScheme.primary.withValues(alpha: isDark ? 0.12 : 0.05)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : done
                ? colorScheme.primary.withValues(alpha: 0.25)
                : colorScheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: done || isDark
              ? null
              : isSelected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : AppShadows.soft,
        ),
        clipBehavior: Clip.hardEdge,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left accent bar
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: 4.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: done
                        ? [
                            colorScheme.primary.withValues(alpha: 0.4),
                            colorScheme.primary.withValues(alpha: 0.18),
                          ]
                        : [colorScheme.primary, colorScheme.primaryContainer],
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 15.h,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Habit icon
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 46.r,
                        height: 46.r,
                        decoration: BoxDecoration(
                          color: done
                              ? colorScheme.primary.withValues(alpha: 0.12)
                              : colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          IconData(
                            habit.habit.iconCodePoint,
                            fontFamily: 'MaterialIcons',
                          ),
                          color: done
                              ? colorScheme.primary.withValues(alpha: 0.6)
                              : colorScheme.primary,
                          size: 23.sp,
                        ),
                      ),

                      SizedBox(width: 14.w),

                      // Title + subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              habit.habit.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 15.sp,
                                color: done
                                    ? colorScheme.onSurfaceVariant
                                    : colorScheme.onSurface,
                                decoration: done
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                decorationColor: colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.6),
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
                                color: done
                                    ? colorScheme.onSurfaceVariant.withValues(
                                        alpha: 0.6,
                                      )
                                    : colorScheme.onSurfaceVariant,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 10.w),

                      // Right side
                      if (isSelected)
                        GestureDetector(
                          onTap: onEdit,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 11.w,
                              vertical: 7.h,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(
                                AppRadius.pill,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.edit_rounded,
                                  color: colorScheme.onPrimary,
                                  size: 13.sp,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  "Edit",
                                  style: AppTextStyles.caption.copyWith(
                                    color: colorScheme.onPrimary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (done)
                        Container(
                          width: 30.r,
                          height: 30.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorScheme.primary.withValues(alpha: 0.12),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.check_rounded,
                            color: colorScheme.primary,
                            size: 17.sp,
                          ),
                        )
                      else
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 9.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                          child: Text(
                            _frequencyLabel(),
                            style: AppTextStyles.caption.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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

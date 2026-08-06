import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habitflow/models/habit/habit_with_completion.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../controllers/habits/habits_bloc.dart';
import '../../../controllers/habits/habits_event.dart';
import '../../../models/habit/habit_model.dart';
import 'habit_card.dart';

class TodaysHabitsSection extends StatelessWidget {
  final List<HabitWithCompletion> habits;
  final ValueChanged<HabitModel> onHabitTap;
  final ValueChanged<HabitModel> onHabitLongPress;
  final ValueChanged<HabitModel> onEditHabit;
  final String? selectedHabitId;

  const TodaysHabitsSection({
    super.key,
    required this.habits,
    required this.onHabitTap,
    required this.onHabitLongPress,
    required this.onEditHabit,
    required this.selectedHabitId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Daily routine",
              style: AppTextStyles.heading2.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 18.sp,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {},
              child: Text(
                "See all",
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: AppSpacing.md),

        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: habits.length,
            itemBuilder: (context, index) {
              final habit = habits[index];
              final isFirst = index == 0;
              final isLast = index == habits.length - 1;
              final isCompleted = habit.isCompletedToday;
              
              final isPrevCompleted = index > 0 && habits[index - 1].isCompletedToday;
              final isNextCompleted = index < habits.length - 1 && habits[index + 1].isCompletedToday;

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Timeline Node & Line Column
                    SizedBox(
                      width: 36.w,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          // Top Half Line Segment
                          if (!isFirst)
                            Positioned(
                              top: 0,
                              height: 27.h,
                              left: 17.w,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                width: 2.w,
                                color: isCompleted && isPrevCompleted
                                    ? AppColors.primary
                                    : AppColors.divider,
                              ),
                            ),

                          // Bottom Half Line Segment
                          if (!isLast)
                            Positioned(
                              top: 27.h,
                              bottom: 0,
                              left: 17.w,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                width: 2.w,
                                color: isCompleted && isNextCompleted
                                    ? AppColors.primary
                                    : AppColors.divider,
                              ),
                            ),

                          // Timeline Checkbox Circle / Button
                          Padding(
                            padding: EdgeInsets.only(top: 14.h),
                            child: GestureDetector(
                              onTap: () => onHabitTap(habit.habit),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                width: 26.r,
                                height: 26.r,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isCompleted
                                      ? AppColors.primary
                                      : Colors.white,
                                  border: Border.all(
                                    color: isCompleted
                                        ? AppColors.primary
                                        : AppColors.border,
                                    width: 2,
                                  ),
                                  boxShadow: isCompleted
                                      ? [
                                          BoxShadow(
                                            color: AppColors.primary
                                                .withValues(alpha: 0.35),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: AnimatedScale(
                                  duration: const Duration(milliseconds: 200),
                                  scale: isCompleted ? 1.0 : 0.0,
                                  child: Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 16.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 8.w),

                    // Habit Card & Swipe Actions
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: isLast ? 0 : AppSpacing.md,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          child: Dismissible(
                            key: ValueKey(habit.habit.id),
                            background: _archiveBackground(),
                            secondaryBackground: _deleteBackground(),
                            // 50% threshold = intentional swipe required (friction)
                            dismissThresholds: const {
                              DismissDirection.startToEnd: 0.5,
                              DismissDirection.endToStart: 0.5,
                            },
                            movementDuration: const Duration(milliseconds: 200),
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                // Medium haptic for archive (softer action)
                                HapticFeedback.mediumImpact();
                                return true;
                              }
                              // Heavy haptic for delete (destructive action)
                              HapticFeedback.heavyImpact();
                              return await _showDeleteDialog(context);
                            },
                            onDismissed: (direction) {
                              if (direction == DismissDirection.startToEnd) {
                                context
                                    .read<HabitsBloc>()
                                    .add(ArchiveHabit(habit.habit.id));

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Habit archived"),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              } else {
                                context
                                    .read<HabitsBloc>()
                                    .add(DeleteHabit(habit.habit.id));

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Habit deleted"),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                            child: HabitCard(
                              habit: habit,
                              isSelected: selectedHabitId == habit.habit.id,
                              onTap: () => onHabitTap(habit.habit),
                              onLongPress: () => onHabitLongPress(habit.habit),
                              onEdit: () => onEditHabit(habit.habit),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _archiveBackground() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.archive_outlined,
              color: Colors.white,
              size: 18.sp,
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            "Archive",
            style: AppTextStyles.body.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _deleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Delete",
            style: AppTextStyles.body.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w700,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(width: 10.w),
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: const BoxDecoration(
              color: AppColors.error,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.delete_outline_rounded,
              color: Colors.white,
              size: 18.sp,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _showDeleteDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            backgroundColor: AppColors.card,
            surfaceTintColor: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(14.r),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.delete_forever_rounded,
                      color: AppColors.error,
                      size: 28.sp,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    "Delete Habit?",
                    style: AppTextStyles.heading2.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 18.sp,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    "This action cannot be undone and will erase all progress for this habit.",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 13.sp,
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.pill),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(
                            "Cancel",
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.error,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.pill),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(
                            "Delete",
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ) ??
        false;
  }
}

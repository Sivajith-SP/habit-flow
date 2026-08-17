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
    final activeHabits =
        habits.where((h) => !h.isCompletedToday).toList();
    final completedHabits =
        habits.where((h) => h.isCompletedToday).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Text(
              "Today's Habits",
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

        SizedBox(height: 14.h),

        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: 100.h),
            children: [
              // Active / Ongoing habits
              if (activeHabits.isEmpty && completedHabits.isNotEmpty)
                const _AllDoneBanner()
              else
                ...List.generate(activeHabits.length, (index) {
                  final habit = activeHabits[index];
                  final isLast = index == activeHabits.length - 1 &&
                      completedHabits.isEmpty;
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: isLast ? 0 : 12.h,
                    ),
                    child: _buildDismissibleCard(context, habit),
                  );
                }),

              // Completed section header (only when there are completed habits)
              if (completedHabits.isNotEmpty) ...[
                SizedBox(height: 20.h),
                _CompletedSectionHeader(count: completedHabits.length),
                SizedBox(height: 14.h),
                ...List.generate(completedHabits.length, (index) {
                  final habit = completedHabits[index];
                  final isLast = index == completedHabits.length - 1;
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: isLast ? 0 : 12.h,
                    ),
                    child: _buildDismissibleCard(context, habit),
                  );
                }),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDismissibleCard(
    BuildContext context,
    HabitWithCompletion habit,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: Dismissible(
        key: ValueKey(habit.habit.id),
        background: _archiveBackground(),
        secondaryBackground: _deleteBackground(),
        dismissThresholds: const {
          DismissDirection.startToEnd: 0.5,
          DismissDirection.endToStart: 0.5,
        },
        movementDuration: const Duration(milliseconds: 200),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            HapticFeedback.mediumImpact();
            return true;
          }
          HapticFeedback.heavyImpact();
          return await _showDeleteDialog(context);
        },
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            context.read<HabitsBloc>().add(ArchiveHabit(habit.habit.id));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Habit archived"),
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else {
            context.read<HabitsBloc>().add(DeleteHabit(habit.habit.id));
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
    );
  }

  Widget _archiveBackground() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.xl),
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
        borderRadius: BorderRadius.circular(AppRadius.xl),
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
                              borderRadius:
                                  BorderRadius.circular(AppRadius.pill),
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
                              borderRadius:
                                  BorderRadius.circular(AppRadius.pill),
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

class _CompletedSectionHeader extends StatelessWidget {
  final int count;
  const _CompletedSectionHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.divider.withValues(alpha: 0.0),
                  AppColors.divider,
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                size: 14.sp,
                color: AppColors.primary.withValues(alpha: 0.55),
              ),
              SizedBox(width: 5.w),
              Text(
                "Completed · $count",
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.divider,
                  AppColors.divider.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AllDoneBanner extends StatelessWidget {
  const _AllDoneBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 18.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42.r,
            height: 42.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.celebration_rounded,
              color: AppColors.primary,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "All Habits Completed! 🎉",
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "You've crushed all your routine tasks for today.",
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

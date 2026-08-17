import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../models/habit/habit_frequency.dart';
import '../../../models/habit/habit_with_completion.dart';

class HabitManagementCard extends StatelessWidget {
  final HabitWithCompletion habit;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onArchive;
  final VoidCallback? onDelete;

  const HabitManagementCard({
    super.key,
    required this.habit,
    this.onTap,
    this.onEdit,
    this.onArchive,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final model = habit.habit;
    final isArchived = model.isArchived;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.35),
            width: 1,
          ),
          boxShadow: AppShadows.soft,
        ),
        clipBehavior: Clip.hardEdge,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left gradient accent bar — matches DashboardHabitCard
              Container(
                width: 4.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isArchived
                        ? [
                            AppColors.border.withValues(alpha: 0.4),
                            AppColors.border.withValues(alpha: 0.2),
                          ]
                        : [
                            AppColors.primary,
                            AppColors.primaryDark,
                          ],
                  ),
                ),
              ),

              // Content area
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icon container
                      Container(
                        width: 46.r,
                        height: 46.r,
                        decoration: BoxDecoration(
                          color: isArchived
                              ? AppColors.border.withValues(alpha: 0.25)
                              : AppColors.primaryLight.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          IconData(
                            model.iconCodePoint,
                            fontFamily: 'MaterialIcons',
                          ),
                          color: isArchived
                              ? AppColors.textMuted
                              : AppColors.primary,
                          size: 23.sp,
                        ),
                      ),

                      SizedBox(width: 14.w),

                      // Title + subtitle + chips
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              model.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 15.sp,
                                color: isArchived
                                    ? AppColors.textMuted
                                    : AppColors.textPrimary,
                              ),
                            ),

                            SizedBox(height: 3.h),

                            Text(
                              model.description.isEmpty
                                  ? _frequencyLabel(model.frequency)
                                  : model.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textMuted,
                                fontSize: 12.sp,
                              ),
                            ),

                            SizedBox(height: AppSpacing.sm),

                            Row(
                              children: [
                                _Chip(
                                  label: _frequencyLabel(model.frequency),
                                  color: AppColors.primaryLight
                                      .withValues(alpha: 0.55),
                                  textColor: AppColors.primary,
                                ),
                                SizedBox(width: AppSpacing.xs),
                                _Chip(
                                  label: isArchived ? 'Archived' : 'Active',
                                  color: isArchived
                                      ? AppColors.accentCream
                                      : AppColors.primaryLight
                                          .withValues(alpha: 0.55),
                                  textColor: isArchived
                                      ? AppColors.textSecondary
                                      : AppColors.primary,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 4.w),

                      // Themed popup menu
                      _ThemedPopupMenu(
                        isArchived: isArchived,
                        onEdit: onEdit,
                        onArchive: onArchive,
                        onDelete: onDelete,
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

  String _frequencyLabel(HabitFrequency frequency) {
    switch (frequency) {
      case HabitFrequency.daily:
        return 'Daily';
      case HabitFrequency.weekly:
        return 'Weekly';
      case HabitFrequency.custom:
        return 'Custom';
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Themed Popup Menu Button
// ─────────────────────────────────────────────────────────────────────────────

class _ThemedPopupMenu extends StatelessWidget {
  final bool isArchived;
  final VoidCallback? onEdit;
  final VoidCallback? onArchive;
  final VoidCallback? onDelete;

  const _ThemedPopupMenu({
    required this.isArchived,
    this.onEdit,
    this.onArchive,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        popupMenuTheme: PopupMenuThemeData(
          color: AppColors.card,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            side: BorderSide(
              color: AppColors.border.withValues(alpha: 0.35),
            ),
          ),
          elevation: 8,
          shadowColor: AppColors.shadow,
          textStyle: AppTextStyles.body.copyWith(
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      child: PopupMenuButton<String>(
        onSelected: (value) {
          switch (value) {
            case 'edit':
              onEdit?.call();
              break;
            case 'archive':
              onArchive?.call();
              break;
            case 'delete':
              onDelete?.call();
              break;
          }
        },
        icon: Container(
          width: 34.r,
          height: 34.r,
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.45),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.more_horiz_rounded,
            color: AppColors.primary,
            size: 18.sp,
          ),
        ),
        padding: EdgeInsets.zero,
        itemBuilder: (_) => [
          _menuItem(
            value: 'edit',
            icon: Icons.edit_rounded,
            label: 'Edit',
            iconColor: AppColors.primary,
          ),
          _menuItem(
            value: 'archive',
            icon: isArchived
                ? Icons.unarchive_rounded
                : Icons.archive_outlined,
            label: isArchived ? 'Restore' : 'Archive',
            iconColor: AppColors.textSecondary,
          ),
          _menuItem(
            value: 'delete',
            icon: Icons.delete_outline_rounded,
            label: 'Delete',
            iconColor: AppColors.error,
            labelColor: AppColors.error,
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _menuItem({
    required String value,
    required IconData icon,
    required String label,
    required Color iconColor,
    Color? labelColor,
  }) {
    return PopupMenuItem<String>(
      value: value,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        children: [
          Icon(icon, size: 18.sp, color: iconColor),
          SizedBox(width: 10.w),
          Text(
            label,
            style: AppTextStyles.body.copyWith(
              fontSize: 14.sp,
              color: labelColor ?? AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Chip Badge — matches dashboard habit card frequency badge
// ─────────────────────────────────────────────────────────────────────────────

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  const _Chip({
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 11.sp,
        ),
      ),
    );
  }
}

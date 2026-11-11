import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_flow_tokens.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../models/habit/habit_frequency.dart';
import '../../../models/habit/habit_with_completion.dart';
import '../../dashboard/widgets/create_habit/icon_cell.dart';

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

  Color _badgeBg(HabitFlowTokens tokens, int codePoint) {
    final mod = codePoint % 4;
    return switch (mod) {
      0 => tokens.tileLavender,
      1 => tokens.tileMint,
      2 => tokens.tileButter,
      _ => tokens.tilePink,
    };
  }

  Color _badgeIcon(HabitFlowTokens tokens, int codePoint) {
    final mod = codePoint % 4;
    return switch (mod) {
      0 => tokens.tileLavenderIcon,
      1 => tokens.tileMintIcon,
      2 => tokens.tileButterIcon,
      _ => tokens.tilePinkIcon,
    };
  }

  @override
  Widget build(BuildContext context) {
    final model = habit.habit;
    final isArchived = model.isArchived;
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final badgeBackground = isArchived
        ? (isDark ? tokens.border : const Color(0xFFF0EDF6))
        : _badgeBg(tokens, model.iconCodePoint);

    final badgeIconColor = isArchived
        ? tokens.mutedText
        : _badgeIcon(tokens, model.iconCodePoint);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 14.h,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left icon badge (round, matching app design system)
            Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                color: badgeBackground,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: isEmojiCodePoint(model.iconCodePoint)
                  ? Text(
                      String.fromCharCode(model.iconCodePoint),
                      style: TextStyle(fontSize: 22.sp, height: 1),
                    )
                  : Icon(
                      IconData(
                        model.iconCodePoint,
                        fontFamily: 'MaterialIcons',
                      ),
                      color: badgeIconColor,
                      size: 24.sp,
                    ),
            ),

            SizedBox(width: 14.w),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    model.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppUrbanist.body(
                      color: isArchived ? tokens.mutedText : tokens.text,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: 3.h),

                  Text(
                    model.description.isEmpty
                        ? _frequencyLabel(model.frequency)
                        : model.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppUrbanist.body(
                      color: tokens.mutedText,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: 6.h),

                  Row(
                    children: [
                      _Chip(
                        label: _frequencyLabel(model.frequency),
                        color: isDark
                            ? tokens.border.withValues(alpha: 0.5)
                            : const Color(0xFFF3F1FA),
                        textColor: tokens.mutedText,
                      ),
                      SizedBox(width: 6.w),
                      _Chip(
                        label: isArchived ? 'Archived' : 'Active',
                        color: isArchived
                            ? (isDark
                                ? tokens.border.withValues(alpha: 0.3)
                                : const Color(0xFFEEEEF3))
                            : (isDark
                                ? const Color(0xFF1E382B)
                                : const Color(0xFFE2F4EA)),
                        textColor: isArchived
                            ? tokens.mutedText
                            : (isDark
                                ? const Color(0xFF5CD898)
                                : const Color(0xFF28795A)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: 8.w),

            // 3-dots popup menu
            _ThemedPopupMenu(
              isArchived: isArchived,
              onEdit: onEdit,
              onArchive: onArchive,
              onDelete: onDelete,
            ),
          ],
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
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Theme(
      data: Theme.of(context).copyWith(
        popupMenuTheme: PopupMenuThemeData(
          color: isDark ? tokens.raised : tokens.surface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: BorderSide(
              color: isDark ? tokens.border : tokens.hairline,
              width: 1,
            ),
          ),
          elevation: 10,
          shadowColor: const Color(0xFF5B43B5).withValues(alpha: 0.12),
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
          width: 36.r,
          height: 36.r,
          decoration: BoxDecoration(
            color: isDark ? tokens.border.withValues(alpha: 0.35) : tokens.raised,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.more_horiz_rounded,
            color: tokens.mutedText,
            size: 20.sp,
          ),
        ),
        padding: EdgeInsets.zero,
        itemBuilder: (_) => [
          _menuItem(
            value: 'edit',
            icon: Icons.edit_outlined,
            label: 'Edit',
            iconColor: tokens.text,
            tokens: tokens,
          ),
          _menuItem(
            value: 'archive',
            icon: isArchived
                ? Icons.unarchive_outlined
                : Icons.archive_outlined,
            label: isArchived ? 'Restore' : 'Archive',
            iconColor: tokens.text,
            tokens: tokens,
          ),
          _menuItem(
            value: 'delete',
            icon: Icons.delete_outline_rounded,
            label: 'Delete',
            iconColor: const Color(0xFFDE3750),
            labelColor: const Color(0xFFDE3750),
            tokens: tokens,
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
    required HabitFlowTokens tokens,
    Color? labelColor,
  }) {
    return PopupMenuItem<String>(
      value: value,
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 4.h,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18.sp,
            color: iconColor,
          ),
          SizedBox(width: 12.w),
          Text(
            label,
            style: AppUrbanist.body(
              color: labelColor ?? tokens.text,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

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
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 3.5.h,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: AppUrbanist.body(
          color: textColor,
          fontSize: 11.5.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

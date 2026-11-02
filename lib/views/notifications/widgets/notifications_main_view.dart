import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_flow_tokens.dart';
import '../../../app/theme/app_spacing.dart';

// =============================================================================
// NotificationsMainView – Main notifications settings list
// =============================================================================

class NotificationsMainView extends StatelessWidget {
  final HabitFlowTokens tokens;
  final bool isDark;
  final bool notificationsEnabled;
  final bool habitRemindersEnabled;
  final int reminderHour;
  final int reminderMinute;
  final ValueChanged<bool> onNotificationsToggle;
  final ValueChanged<bool> onHabitRemindersToggle;
  final VoidCallback onReminderTimeTap;

  const NotificationsMainView({
    super.key,
    required this.tokens,
    required this.isDark,
    required this.notificationsEnabled,
    required this.habitRemindersEnabled,
    required this.reminderHour,
    required this.reminderMinute,
    required this.onNotificationsToggle,
    required this.onHabitRemindersToggle,
    required this.onReminderTimeTap,
  });

  static String formatTime(int hour, int minute) {
    final tod = TimeOfDay(hour: hour, minute: minute);
    final h = tod.hourOfPeriod == 0 ? 12 : tod.hourOfPeriod;
    final m = tod.minute.toString().padLeft(2, '0');
    final period = tod.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    final timeLabel = formatTime(reminderHour, reminderMinute);
    final reminderEnabled = notificationsEnabled && habitRemindersEnabled;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        8.h,
        AppSpacing.screenPadding,
        28.h + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Notifications',
            style: AppUrbanist.sectionTitle(color: tokens.text),
          ),
          SizedBox(height: AppSpacing.xxs),
          Text(
            'Manage your habit reminders',
            style: AppUrbanist.body(
              color: tokens.mutedText,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 20.h),

          // Section label
          Padding(
            padding: EdgeInsets.only(left: 2.w, bottom: AppSpacing.sm),
            child: Text(
              'REMINDERS',
              style: AppUrbanist.daysCaption(color: tokens.accent),
            ),
          ),

          // Notification options card
          Container(
            decoration: BoxDecoration(
              color: isDark ? tokens.raised : tokens.surface,
              borderRadius: BorderRadius.circular(20.r),
              border: isDark
                  ? Border.all(color: tokens.border, width: 1)
                  : null,
              boxShadow: isDark ? null : tokens.cardShadow,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Column(
                children: [
                  // Notifications toggle
                  NotificationTile(
                    icon: Icons.notifications_none_rounded,
                    iconBg: tokens.tileLavender,
                    iconColor: tokens.tileLavenderIcon,
                    title: 'Notifications',
                    subtitle: notificationsEnabled ? 'Enabled' : 'Disabled',
                    trailing: Switch.adaptive(
                      value: notificationsEnabled,
                      onChanged: onNotificationsToggle,
                      activeTrackColor: tokens.accent,
                    ),
                    tokens: tokens,
                  ),

                  _SheetDivider(tokens: tokens),

                  // Habit Reminders toggle
                  NotificationTile(
                    icon: Icons.alarm_outlined,
                    iconBg: tokens.tileMint,
                    iconColor: tokens.tileMintIcon,
                    title: 'Habit Reminders',
                    subtitle: 'Daily check-in',
                    enabled: notificationsEnabled,
                    trailing: Switch.adaptive(
                      value: habitRemindersEnabled,
                      onChanged:
                          notificationsEnabled ? onHabitRemindersToggle : null,
                      activeTrackColor: tokens.accent,
                    ),
                    tokens: tokens,
                  ),

                  _SheetDivider(tokens: tokens),

                  // Reminder Time row -> opens in-sheet subview
                  NotificationTile(
                    icon: Icons.schedule_outlined,
                    iconBg: tokens.tileButter,
                    iconColor: tokens.tileButterIcon,
                    title: 'Reminder Time',
                    subtitle: timeLabel,
                    enabled: reminderEnabled,
                    showChevron: true,
                    onTap: reminderEnabled ? onReminderTimeTap : null,
                    tokens: tokens,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// NotificationTile – Reusable list tile inside the sheet
// =============================================================================

class NotificationTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final bool showChevron;
  final bool enabled;
  final VoidCallback? onTap;
  final HabitFlowTokens tokens;

  const NotificationTile({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.tokens,
    this.trailing,
    this.showChevron = false,
    this.enabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.45,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            child: Row(
              children: [
                // Icon badge
                Container(
                  width: 42.r,
                  height: 42.r,
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, color: iconColor, size: 20.sp),
                ),

                SizedBox(width: 14.w),

                // Title & Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppUrbanist.body(
                          color: tokens.text,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppUrbanist.body(
                          color: tokens.mutedText,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                ?trailing,

                if (showChevron)
                  Icon(
                    Icons.chevron_right_rounded,
                    color: tokens.mutedText.withValues(alpha: 0.60),
                    size: 20.sp,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// _SheetDivider – Thin separator matching security screen
// =============================================================================

class _SheetDivider extends StatelessWidget {
  final HabitFlowTokens tokens;

  const _SheetDivider({required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 72.w,
      endIndent: 16.w,
      color: tokens.mutedText.withValues(alpha: 0.12),
    );
  }
}

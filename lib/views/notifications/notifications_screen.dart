import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import '../../controllers/notifications/notifications_bloc.dart';
import '../../controllers/notifications/notifications_event.dart';
import '../../controllers/notifications/notifications_state.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  String _formatTime(int hour, int minute) {
    final time = TimeOfDay(
      hour: hour,
      minute: minute,
    );

    final formattedHour =
    time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;

    final formattedMinute =
    time.minute.toString().padLeft(2, '0');

    final period =
    time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$formattedHour:$formattedMinute $period';
  }

  Future<void> _pickReminderTime(
      BuildContext context,
      int hour,
      int minute,
      ) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: hour,
        minute: minute,
      ),
    );

    if (selectedTime == null || !context.mounted) return;

    context.read<NotificationsBloc>().add(
      ReminderTimeChanged(
        hour: selectedTime.hour,
        minute: selectedTime.minute,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),

              // Header
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: colorScheme.onSurface,
                    ),
                  ),

                  SizedBox(width: AppSpacing.md),

                  Text(
                    'Notifications',
                    style: AppTextStyles.heading1.copyWith(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                      height: 1.15,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 4.h),

              Padding(
                padding: EdgeInsets.only(left: 48.w),
                child: Text(
                  'Manage your habit reminders',
                  style: AppTextStyles.body.copyWith(
                    fontSize: 14.sp,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.xl),

              Expanded(
                child: BlocBuilder<NotificationsBloc,
                    NotificationsState>(
                  builder: (context, state) {
                    if (state is NotificationsLoading ||
                        state is NotificationsInitial) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (state is NotificationsFailure) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppSpacing.lg),
                          child: Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.body.copyWith(
                              color: colorScheme.error,
                            ),
                          ),
                        ),
                      );
                    }

                    if (state is NotificationsLoaded) {
                      final settings = state.settings;

                      return ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(
                          bottom: 100.h,
                        ),
                        children: [
                          _SectionTitle(
                            title: 'Notifications',
                          ),

                          SizedBox(height: AppSpacing.sm),

                          _NotificationCard(
                            children: [
                              _NotificationRow(
                                icon:
                                Icons.notifications_none_rounded,
                                title: 'Notifications',
                                subtitle: settings
                                    .notificationsEnabled
                                    ? 'Notifications are enabled'
                                    : 'Notifications are disabled',
                                trailing: Switch.adaptive(
                                  value:
                                  settings.notificationsEnabled,
                                  onChanged: (value) {
                                    context
                                        .read<NotificationsBloc>()
                                        .add(
                                      NotificationsEnabledChanged(
                                        value,
                                      ),
                                    );
                                  },
                                ),
                              ),

                              _NotificationDivider(),

                              _NotificationRow(
                                icon: Icons.alarm_outlined,
                                title: 'Habit Reminders',
                                subtitle: settings
                                    .habitRemindersEnabled
                                    ? 'Receive reminders for your habits'
                                    : 'Habit reminders are disabled',
                                trailing: Switch.adaptive(
                                  value:
                                  settings.habitRemindersEnabled,
                                  onChanged:
                                  settings.notificationsEnabled
                                      ? (value) {
                                    context
                                        .read<
                                        NotificationsBloc>()
                                        .add(
                                      HabitRemindersEnabledChanged(
                                        value,
                                      ),
                                    );
                                  }
                                      : null,
                                ),
                              ),

                              _NotificationDivider(),

                              _NotificationRow(
                                icon: Icons.schedule_outlined,
                                title: 'Reminder Time',
                                subtitle: _formatTime(
                                  settings.reminderHour,
                                  settings.reminderMinute,
                                ),
                                showChevron: true,
                                enabled:
                                settings.notificationsEnabled &&
                                    settings.habitRemindersEnabled,
                                onTap:
                                settings.notificationsEnabled &&
                                    settings
                                        .habitRemindersEnabled
                                    ? () => _pickReminderTime(
                                  context,
                                  settings.reminderHour,
                                  settings.reminderMinute,
                                )
                                    : null,
                              ),
                            ],
                          ),

                          SizedBox(height: AppSpacing.xl),

                          _SectionTitle(
                            title: 'Information',
                          ),

                          SizedBox(height: AppSpacing.sm),

                          _NotificationCard(
                            children: [
                              Padding(
                                padding:
                                EdgeInsets.all(AppSpacing.md),
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 40.r,
                                      height: 40.r,
                                      decoration: BoxDecoration(
                                        color: colorScheme.primary
                                            .withValues(alpha: 0.14),
                                        borderRadius:
                                        BorderRadius.circular(
                                          AppRadius.sm,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.info_outline_rounded,
                                        color: colorScheme.primary,
                                        size: 20.sp,
                                      ),
                                    ),

                                    SizedBox(
                                      width: AppSpacing.md,
                                    ),

                                    Expanded(
                                      child: Text(
                                        'HabitFlow can remind you about your habits at your selected time.',
                                        style: AppTextStyles.caption
                                            .copyWith(
                                          color: colorScheme
                                              .onSurfaceVariant,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.caption.copyWith(
          color: colorScheme.primary,
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final List<Widget> children;

  const _NotificationCard({
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final bool showChevron;
  final bool enabled;
  final VoidCallback? onTap;

  const _NotificationRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.showChevron = false,
    this.enabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final contentOpacity = enabled ? 1.0 : 0.45;

    return Opacity(
      opacity: contentOpacity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 14.h,
            ),
            child: Row(
              children: [
                Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(
                      alpha: 0.14,
                    ),
                    borderRadius: BorderRadius.circular(
                      AppRadius.sm,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: colorScheme.primary,
                    size: 20.sp,
                  ),
                ),

                SizedBox(width: AppSpacing.md),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),

                      SizedBox(height: 2.h),

                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color:
                          colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: AppSpacing.sm),

                if (trailing != null) trailing!,

                if (showChevron)
                  Icon(
                    Icons.chevron_right_rounded,
                    color:
                    colorScheme.onSurfaceVariant,
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

class _NotificationDivider extends StatelessWidget {
  const _NotificationDivider();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Divider(
      height: 1,
      thickness: 1,
      indent: 56.w,
      endIndent: AppSpacing.md,
      color: colorScheme.outlineVariant.withValues(
        alpha: 0.5,
      ),
    );
  }
}
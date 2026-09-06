import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_routes.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import '../../controllers/theme/theme_cubit.dart';
import 'widgets/settings_section.dart';
import 'widgets/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  String _getThemeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System default';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  void _showThemeBottomSheet(BuildContext context, ThemeMode currentMode) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  'Choose Theme',
                  style: AppTextStyles.title.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                for (final entry in [
                  (
                    ThemeMode.system,
                    'System default',
                    Icons.brightness_auto_rounded,
                  ),
                  (ThemeMode.light, 'Light', Icons.light_mode_rounded),
                  (ThemeMode.dark, 'Dark', Icons.dark_mode_rounded),
                ])
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      entry.$3,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    title: Text(
                      entry.$2,
                      style: AppTextStyles.body.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    trailing: currentMode == entry.$1
                        ? Icon(
                            Icons.check_circle_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                    onTap: () {
                      context.read<ThemeCubit>().setThemeMode(entry.$1);
                      Navigator.pop(sheetContext);
                    },
                  ),
                SizedBox(height: AppSpacing.sm),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Matches StatisticsScreen / DashboardScreen pattern exactly:
    // DecoratedBox → SafeArea(bottom: false) → Padding → Column
    //   [fixed header] + [Expanded ListView with bottom padding to clear nav bar]
    return DecoratedBox(
      decoration: BoxDecoration(color: colorScheme.surface),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),

              // ── Page title ──────────────────────────────────────────────
              Text(
                'Settings',
                style: AppTextStyles.heading1.copyWith(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  height: 1.15,
                ),
              ),

              SizedBox(height: 2.h),

              Text(
                'Manage your app preferences',
                style: AppTextStyles.body.copyWith(
                  fontSize: 14.sp,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

              SizedBox(height: AppSpacing.lg),

              // ── Scrollable content ───────────────────────────────────────
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  // Bottom padding clears the floating nav bar (same as Statistics)
                  padding: EdgeInsets.only(bottom: 100.h),
                  children: [
                    // ── Account ────────────────────────────────────────────
                    SettingsSection(
                      title: 'Account',
                      children: [
                        SettingsTile(
                          icon: Icons.person_outline_rounded,
                          title: 'Profile',
                          subtitle: 'Manage your account details',
                          onTap: () => context.push(AppRoutes.profile),
                        ),
                        SettingsTile(
                          icon: Icons.lock_outline_rounded,
                          title: 'Security',
                          subtitle: 'Manage your account security',
                          onTap: () {
                            context.push(AppRoutes.security);
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: AppSpacing.xl),

                    // ── Appearance ─────────────────────────────────────────
                    SettingsSection(
                      title: 'Appearance',
                      children: [
                        BlocBuilder<ThemeCubit, ThemeMode>(
                          builder: (context, themeMode) {
                            return SettingsTile(
                              icon: Icons.dark_mode_outlined,
                              title: 'Theme',
                              subtitle: _getThemeLabel(themeMode),
                              onTap: () =>
                                  _showThemeBottomSheet(context, themeMode),
                            );
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: AppSpacing.xl),

                    // ── Preferences ────────────────────────────────────────
                    SettingsSection(
                      title: 'Preferences',
                      children: [
                        SettingsTile(
                          icon: Icons.notifications_none_rounded,
                          title: 'Notifications',
                          subtitle: 'Manage habit reminders',
                          onTap: () {},
                        ),
                        SettingsTile(
                          icon: Icons.language_rounded,
                          title: 'Language',
                          subtitle: 'English',
                          onTap: () {},
                        ),
                      ],
                    ),

                    SizedBox(height: AppSpacing.xl),

                    // ── About ──────────────────────────────────────────────
                    SettingsSection(
                      title: 'About',
                      children: [
                        SettingsTile(
                          icon: Icons.info_outline_rounded,
                          title: 'About HabitFlow',
                          subtitle: 'App version and information',
                          onTap: () {},
                        ),
                        SettingsTile(
                          icon: Icons.privacy_tip_outlined,
                          title: 'Privacy',
                          subtitle: 'How your data is handled',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

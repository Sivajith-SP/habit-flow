import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      builder: (sheetContext) {
        return SafeArea(
          child: Container(
            padding: .all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('System default'),
                  trailing: currentMode == ThemeMode.system
                      ? const Icon(Icons.check_rounded)
                      : null,
                  onTap: () {
                    context.read<ThemeCubit>().setThemeMode(ThemeMode.system);
                    Navigator.pop(sheetContext);
                  },
                ),
                ListTile(
                  title: const Text('Light'),
                  trailing: currentMode == ThemeMode.light
                      ? const Icon(Icons.check_rounded)
                      : null,
                  onTap: () {
                    context.read<ThemeCubit>().setThemeMode(ThemeMode.light);
                    Navigator.pop(sheetContext);
                  },
                ),
                ListTile(
                  title: const Text('Dark'),
                  trailing: currentMode == ThemeMode.dark
                      ? const Icon(Icons.check_rounded)
                      : null,
                  onTap: () {
                    context.read<ThemeCubit>().setThemeMode(ThemeMode.dark);
                    Navigator.pop(sheetContext);
                  },
                ),
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: AppTextStyles.heading2.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),

              SizedBox(height: AppSpacing.xs),

              Text(
                'Manage your app preferences',
                style: AppTextStyles.body.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

              SizedBox(height: AppSpacing.xl),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SettingsSection(
                        title: 'Account',
                        children: [
                          SettingsTile(
                            icon: Icons.person_outline_rounded,
                            title: 'Profile',
                            subtitle: 'Manage your account details',
                            onTap: () {
                              context.push(AppRoutes.profile);
                            },
                          ),

                          SettingsTile(
                            icon: Icons.lock_outline_rounded,
                            title: 'Security',
                            subtitle: 'Manage your account security',
                            onTap: () {},
                          ),

                          SizedBox(height: AppSpacing.xl),

                          SettingsSection(
                            title: 'Appearance',
                            children: [
                              BlocBuilder<ThemeCubit, ThemeMode>(
                                builder: (context, themeMode) {
                                  return SettingsTile(
                                    icon: Icons.dark_mode_outlined,
                                    title: 'Theme',
                                    subtitle: _getThemeLabel(themeMode),
                                    onTap: () {
                                      _showThemeBottomSheet(context, themeMode);
                                    },
                                  );
                                },
                              ),
                            ],
                          ),

                          SizedBox(height: AppSpacing.xl),

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

                              SizedBox(height: AppSpacing.xl),

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
                        ],
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
}

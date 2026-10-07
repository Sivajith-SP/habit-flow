import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../app/config/service_locator.dart';
import '../../app/router/app_routes.dart';
import '../../app/theme/app_flow_tokens.dart';
import '../../controllers/auth/auth_bloc.dart';
import '../../controllers/auth/auth_state.dart';
import '../../controllers/theme/theme_cubit.dart';
import '../../repositories/auth/auth_repository.dart';
import 'widgets/settings_section.dart';
import 'widgets/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showThemeBottomSheet(BuildContext context, ThemeMode currentMode) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? tokens.raised : tokens.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 20.h),
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
                      color: tokens.mutedText.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Choose Theme',
                  style: AppUrbanist.sheetTitle(color: tokens.text),
                ),
                SizedBox(height: 12.h),
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
                    contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
                    leading: Icon(
                      entry.$3,
                      color: currentMode == entry.$1
                          ? tokens.accent
                          : tokens.mutedText,
                    ),
                    title: Text(
                      entry.$2,
                      style: AppUrbanist.body(
                        color: tokens.text,
                        fontWeight: currentMode == entry.$1
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                    trailing: currentMode == entry.$1
                        ? Icon(
                            Icons.check_circle_rounded,
                            color: tokens.accent,
                          )
                        : null,
                    onTap: () {
                      context.read<ThemeCubit>().setThemeMode(entry.$1);
                      Navigator.pop(sheetContext);
                    },
                  ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final systemBottom = MediaQuery.of(context).viewPadding.bottom;
    final listBottom = 74.h + 24.h + systemBottom + 16.h;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          context.go(AppRoutes.login);
        }
      },
      child: ColoredBox(
        color: tokens.background,
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Fixed Header ─────────────────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settings',
                      style: AppUrbanist.sheetTitle(color: tokens.text),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Manage your app preferences',
                      style: AppUrbanist.body(color: tokens.mutedText),
                    ),
                  ],
                ),
              ),

              // ── Scrollable Body ──────────────────────────────────────
              Expanded(
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    const fadeHeight = 24.0;
                    final stop = (fadeHeight / bounds.height).clamp(0.01, 0.12);
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: const [Colors.transparent, Colors.black],
                      stops: [0.0, stop],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, listBottom),
                    children: [
                      // ── 1. Top Profile Hero Card ─────────────────────────
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, authState) {
                          String fullName = 'HabitFlow User';
                          String email = 'user@habitflow.app';

                          final authRepo = getIt.isRegistered<AuthRepository>()
                              ? getIt<AuthRepository>()
                              : null;

                          if (authRepo != null) {
                            final repoName =
                                authRepo.currentUserDisplayName?.trim();
                            if (repoName != null && repoName.isNotEmpty) {
                              fullName = repoName;
                            }
                            if (authRepo.currentUserEmail != null) {
                              email = authRepo.currentUserEmail!;
                            }
                          }

                          if (authState is AuthSuccess &&
                              authState.userName.trim().isNotEmpty) {
                            fullName = authState.userName.trim();
                          }

                          final initial = fullName.trim().isNotEmpty
                              ? fullName.trim()[0].toUpperCase()
                              : 'H';

                          return Container(
                            decoration: BoxDecoration(
                              color: tokens.tileLavender,
                              borderRadius: BorderRadius.circular(24.r),
                              border: isDark
                                  ? Border.all(color: tokens.border, width: 1)
                                  : null,
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(24.r),
                                onTap: () => context.push(AppRoutes.profile),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 16.h,
                                  ),
                                  child: Row(
                                    children: [
                                      // Avatar circle with user initial
                                      Container(
                                        width: 50.r,
                                        height: 50.r,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isDark
                                              ? tokens.raised
                                              : Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: tokens.tileLavenderIcon
                                                  .withValues(alpha: 0.12),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          initial,
                                          style: AppUrbanist.body(
                                            color: tokens.tileLavenderIcon,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),

                                      SizedBox(width: 14.w),

                                      // Name and email
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              fullName,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: AppUrbanist.body(
                                                color: tokens.text,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(height: 2.h),
                                            Text(
                                              email,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: AppUrbanist.body(
                                                color: tokens.mutedText,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(width: 8.w),

                                      Icon(
                                        Icons.chevron_right_rounded,
                                        color: tokens.tileLavenderIcon,
                                        size: 22.sp,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 20.h),

                      // ── 2. Security Section ──────────────────────────────
                      SettingsSection(
                        title: 'Security',
                        children: [
                          SettingsTile(
                            icon: Icons.lock_outline_rounded,
                            iconBg: tokens.tileLavender,
                            iconColor: tokens.tileLavenderIcon,
                            title: 'Security',
                            subtitle: 'Password and account protection',
                            onTap: () => context.push(AppRoutes.security),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      // ── 3. Appearance Section ────────────────────────────
                      SettingsSection(
                        title: 'Appearance',
                        children: [
                          BlocBuilder<ThemeCubit, ThemeMode>(
                            builder: (context, themeMode) {
                              final isThemeDark = themeMode == ThemeMode.dark ||
                                  (themeMode == ThemeMode.system &&
                                      MediaQuery.platformBrightnessOf(
                                              context) ==
                                          Brightness.dark);

                              final subtitle = themeMode == ThemeMode.system
                                  ? 'System (${isThemeDark ? 'Dark' : 'Light'})'
                                  : (isThemeDark ? 'On' : 'Off');

                              return SettingsTile(
                                icon: isThemeDark
                                    ? Icons.dark_mode_outlined
                                    : Icons.wb_sunny_outlined,
                                iconBg: tokens.tileMint,
                                iconColor: tokens.tileMintIcon,
                                title: 'Dark mode',
                                subtitle: subtitle,
                                trailing: Switch.adaptive(
                                  value: isThemeDark,
                                  activeThumbColor: tokens.accent,
                                  activeTrackColor:
                                      tokens.accent.withValues(alpha: 0.35),
                                  inactiveThumbColor: Colors.white,
                                  inactiveTrackColor: isDark
                                      ? tokens.field
                                      : const Color(0xFFE2DFEB),
                                  onChanged: (val) {
                                    context.read<ThemeCubit>().setThemeMode(
                                          val
                                              ? ThemeMode.dark
                                              : ThemeMode.light,
                                        );
                                  },
                                ),
                                onTap: () =>
                                    _showThemeBottomSheet(context, themeMode),
                              );
                            },
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      // ── 4. Preferences Section ───────────────────────────
                      SettingsSection(
                        title: 'Preferences',
                        children: [
                          SettingsTile(
                            icon: Icons.notifications_none_rounded,
                            iconBg: tokens.tileButter,
                            iconColor: tokens.tileButterIcon,
                            title: 'Notifications',
                            subtitle: 'Manage habit reminders',
                            onTap: () => context.push(AppRoutes.notifications),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      // ── 5. About Section ─────────────────────────────────
                      SettingsSection(
                        title: 'About',
                        children: [
                          SettingsTile(
                            icon: Icons.info_outline_rounded,
                            iconBg: tokens.tilePink,
                            iconColor: tokens.tilePinkIcon,
                            title: 'About HabitFlow',
                            subtitle: 'App version and information',
                            onTap: () => context.push(AppRoutes.about),
                          ),
                          SettingsTile(
                            icon: Icons.privacy_tip_outlined,
                            iconBg: tokens.tilePink,
                            iconColor: tokens.tilePinkIcon,
                            title: 'Privacy',
                            subtitle: 'How your data is handled',
                            onTap: () => context.push(AppRoutes.privacy),
                          ),
                        ],
                      ),

                      SizedBox(height: 32.h),

                      // ── App Name & Version Footer ────────────────────────
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'HabitFlow',
                              style: AppUrbanist.body(
                                color: tokens.mutedText,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Version 1.0.0',
                              style: AppUrbanist.body(
                                color: tokens.mutedText.withValues(alpha: 0.60),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
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
}

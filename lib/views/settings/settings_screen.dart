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
import 'widgets/settings_bento_card.dart';
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

  Widget _buildDivider(bool isDark, HabitFlowTokens tokens) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 72.w,
      endIndent: 16.w,
      color: isDark
          ? tokens.border.withValues(alpha: 0.5)
          : const Color(0xFFF0EDF6),
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
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 14.h),
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
                    const fadeHeight = 20.0;
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
                    padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, listBottom),
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
                              color: isDark ? tokens.raised : tokens.surface,
                              borderRadius: BorderRadius.circular(24.r),
                              border: isDark
                                  ? Border.all(color: tokens.border, width: 1)
                                  : null,
                              boxShadow: isDark ? null : tokens.cardShadow,
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
                                      // Avatar circle with initial
                                      Container(
                                        width: 50.r,
                                        height: 50.r,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isDark
                                              ? tokens.tileLavender
                                                  .withValues(alpha: 0.35)
                                              : tokens.tileLavender,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          initial,
                                          style: AppUrbanist.body(
                                            color: tokens.tileLavenderIcon,
                                            fontSize: 22.sp,
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
                                                fontSize: 16.sp,
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
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(width: 8.w),

                                      Icon(
                                        Icons.chevron_right_rounded,
                                        color: tokens.mutedText
                                            .withValues(alpha: 0.60),
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

                      SizedBox(height: 16.h),

                      // ── 2. 2-Column Bento Grid: Security & Password ──────
                      Row(
                        children: [
                          Expanded(
                            child: SettingsBentoCard(
                              icon: Icons.lock_outline_rounded,
                              title: 'Security',
                              subtitle: 'Account protection',
                              bgColor: tokens.tileLavender,
                              iconBg: tokens.tileLavenderIcon,
                              iconColor: isDark
                                  ? tokens.background
                                  : Colors.white,
                              onTap: () => context.push(AppRoutes.security),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: SettingsBentoCard(
                              icon: Icons.key_rounded,
                              title: 'Password',
                              subtitle: 'Change password',
                              bgColor: tokens.tileLavender,
                              iconBg: tokens.tileLavenderIcon,
                              iconColor: isDark
                                  ? tokens.background
                                  : Colors.white,
                              onTap: () =>
                                  context.push(AppRoutes.changePassword),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      // ── 3. Single Unified Modern List Card ───────────────
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? tokens.raised : tokens.surface,
                          borderRadius: BorderRadius.circular(24.r),
                          border: isDark
                              ? Border.all(color: tokens.border, width: 1)
                              : null,
                          boxShadow: isDark ? null : tokens.cardShadow,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24.r),
                          child: Column(
                            children: [
                              // Dark mode tile
                              BlocBuilder<ThemeCubit, ThemeMode>(
                                builder: (context, themeMode) {
                                  final isThemeDark = themeMode ==
                                          ThemeMode.dark ||
                                      (themeMode == ThemeMode.system &&
                                          MediaQuery.platformBrightnessOf(
                                                  context) ==
                                              Brightness.dark);

                                  final subtitle =
                                      themeMode == ThemeMode.system
                                          ? 'System'
                                          : (isThemeDark ? 'On' : 'Off');

                                  return SettingsTile(
                                    icon: Icons.nightlight_round,
                                    iconBg: tokens.tileMintIcon,
                                    iconColor: isDark
                                        ? tokens.background
                                        : Colors.white,
                                    title: 'Dark mode',
                                    subtitle: subtitle,
                                    trailing: Switch.adaptive(
                                      value: isThemeDark,
                                      activeThumbColor: tokens.accent,
                                      activeTrackColor: tokens.accent
                                          .withValues(alpha: 0.35),
                                      inactiveThumbColor: Colors.white,
                                      inactiveTrackColor: isDark
                                          ? tokens.field
                                          : const Color(0xFFE2DFEB),
                                      onChanged: (val) {
                                        context
                                            .read<ThemeCubit>()
                                            .setThemeMode(
                                              val
                                                  ? ThemeMode.dark
                                                  : ThemeMode.light,
                                            );
                                      },
                                    ),
                                    onTap: () => _showThemeBottomSheet(
                                        context, themeMode),
                                  );
                                },
                              ),

                              _buildDivider(isDark, tokens),

                              // Notifications tile (no red dot)
                              SettingsTile(
                                icon: Icons.notifications_none_rounded,
                                iconBg: tokens.tileButterIcon,
                                iconColor: isDark
                                    ? tokens.background
                                    : Colors.white,
                                title: 'Notifications',
                                subtitle: 'Habit reminders & alerts',
                                onTap: () =>
                                    context.push(AppRoutes.notifications),
                              ),

                              _buildDivider(isDark, tokens),

                              // About HabitFlow tile
                              SettingsTile(
                                icon: Icons.info_outline_rounded,
                                iconBg: tokens.tilePinkIcon,
                                iconColor: isDark
                                    ? tokens.background
                                    : Colors.white,
                                title: 'About HabitFlow',
                                subtitle: 'App version & info',
                                onTap: () => context.push(AppRoutes.about),
                              ),

                              _buildDivider(isDark, tokens),

                              // Privacy tile
                              SettingsTile(
                                icon: Icons.privacy_tip_outlined,
                                iconBg: tokens.tilePinkIcon,
                                iconColor: isDark
                                    ? tokens.background
                                    : Colors.white,
                                title: 'Privacy',
                                subtitle: 'Data & security',
                                onTap: () => context.push(AppRoutes.privacy),
                              ),
                            ],
                          ),
                        ),
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
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Version 1.0.0',
                              style: AppUrbanist.body(
                                color:
                                    tokens.mutedText.withValues(alpha: 0.60),
                                fontSize: 11.sp,
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

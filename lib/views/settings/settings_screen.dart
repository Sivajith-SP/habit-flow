import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../app/config/service_locator.dart';
import '../../app/router/app_routes.dart';
import '../../app/theme/app_flow_tokens.dart';
import '../../app/theme/app_spacing.dart';
import '../../controllers/auth/auth_bloc.dart';
import '../../controllers/auth/auth_state.dart';
import '../../repositories/auth/auth_repository.dart';
import 'widgets/appearance_tile.dart';
import 'widgets/member_profile_card.dart';
import 'widgets/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // ── Helpers ────────────────────────────────────────────────────────────────

  Widget _buildDivider(bool isDark, HabitFlowTokens tokens) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: AppSpacing.dividerIndent,
      endIndent: AppSpacing.md,
      color: isDark
          ? tokens.border.withValues(alpha: 0.5)
          : const Color(0xFFF0EDF6),
    );
  }

  /// Derives a 4-character display suffix from the user ID.
  String _habitflowId(String? userId) {
    if (userId == null || userId.isEmpty) return '0000';
    final chars = userId.replaceAll(RegExp(r'[^0-9a-zA-Z]'), '');
    if (chars.length >= 4) {
      return chars.substring(chars.length - 4).toUpperCase();
    }
    return chars.toUpperCase().padLeft(4, '0');
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final systemBottom = MediaQuery.of(context).viewPadding.bottom;
    final listBottom = 74.h + 24.h + systemBottom + 32.h;

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
              // ── Fixed Header ──────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  AppSpacing.gap12,
                  AppSpacing.screenPadding,
                  AppSpacing.gap10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settings',
                      style: AppUrbanist.sheetTitle(color: tokens.text),
                    ),
                    SizedBox(height: AppSpacing.xxs),
                    Text(
                      'Manage your app preferences',
                      style: AppUrbanist.body(color: tokens.mutedText),
                    ),
                  ],
                ),
              ),

              // ── Scrollable Body ───────────────────────────────────────────
              Expanded(
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    const fadeHeight = 14.0;
                    final stop =
                        (fadeHeight / bounds.height).clamp(0.01, 0.12);
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
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.screenPadding,
                      AppSpacing.gap14,
                      AppSpacing.screenPadding,
                      listBottom,
                    ),
                    children: [
                      // ── 1. Member Profile Card ────────────────────────────
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, authState) {
                          String fullName = 'HabitFlow User';
                          String email = 'user@habitflow.app';
                          String? userId;

                          final authRepo =
                              getIt.isRegistered<AuthRepository>()
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
                            userId = authRepo.currentUserId;
                          }

                          if (authState is AuthSuccess &&
                              authState.userName.trim().isNotEmpty) {
                            fullName = authState.userName.trim();
                          }

                          final year = DateTime.now().year.toString();
                          final idSuffix = _habitflowId(userId);
                          final hfId = 'HF · $year · $idSuffix';

                          return MemberProfileCard(
                            fullName: fullName,
                            email: email,
                            habitflowId: hfId,
                            onTap: () => context.push(AppRoutes.profile),
                          );
                        },
                      ),

                      SizedBox(height: AppSpacing.gap26),

                      // ── 2. Unified List Card ──────────────────────────────
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
                              // Security tile — opens bottom sheet via GoRouter
                              SettingsTile(
                                icon: Icons.lock_outline_rounded,
                                iconBg: tokens.tileLavender,
                                iconColor: tokens.tileLavenderIcon,
                                title: 'Security',
                                subtitle: 'Account protection',
                                onTap: () => context.push(AppRoutes.security),
                              ),

                              _buildDivider(isDark, tokens),

                              // Appearance expandable tile
                              const AppearanceTile(),

                              _buildDivider(isDark, tokens),

                              // Notifications tile
                              SettingsTile(
                                icon: Icons.notifications_none_rounded,
                                iconBg: tokens.tileButter,
                                iconColor: tokens.tileButterIcon,
                                title: 'Notifications',
                                subtitle: 'Habit reminders & alerts',
                                onTap: () =>
                                    context.push(AppRoutes.notifications),
                              ),

                              _buildDivider(isDark, tokens),

                              // About HabitFlow tile
                              SettingsTile(
                                icon: Icons.info_outline_rounded,
                                iconBg: tokens.tilePink,
                                iconColor: tokens.tilePinkIcon,
                                title: 'About HabitFlow',
                                subtitle: 'App version & info',
                                onTap: () => context.push(AppRoutes.about),
                              ),

                              _buildDivider(isDark, tokens),

                              // Privacy tile
                              SettingsTile(
                                icon: Icons.privacy_tip_outlined,
                                iconBg: tokens.tileLavender,
                                iconColor: tokens.tileLavenderIcon,
                                title: 'Privacy',
                                subtitle: 'Data & security',
                                onTap: () => context.push(AppRoutes.privacy),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: AppSpacing.gap36),

                      // ── App Name & Version Footer ─────────────────────────
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'HabitFlow',
                              style: AppUrbanist.body(
                                color: tokens.text,
                                fontSize: 13.5.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              'Version 1.0.0',
                              style: AppUrbanist.body(
                                color: tokens.mutedText,
                                fontSize: 12.sp,
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

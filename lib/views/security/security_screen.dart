import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_flow_tokens.dart';
import '../../app/theme/app_spacing.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_rounded,
            color: tokens.text,
          ),
        ),
        title: Text(
          'Security',
          style: AppUrbanist.sectionTitle(color: tokens.text),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            20.w,
            12.h,
            20.w,
            100.h,
          ),
          children: [
            // ── Account Security Section ──────────────────────────────────
            Padding(
              padding: EdgeInsets.only(left: 2.w, bottom: AppSpacing.sm),
              child: Text(
                'ACCOUNT SECURITY',
                style: AppUrbanist.daysCaption(color: tokens.accent),
              ),
            ),

            // Account Security Card
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
                    _SecurityTile(
                      icon: Icons.lock_outline_rounded,
                      iconBg: tokens.tileLavender,
                      iconColor: tokens.tileLavenderIcon,
                      title: 'Change Password',
                      subtitle: 'Update your account password',
                      onTap: () => context.push(AppRoutes.changePassword),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: AppSpacing.xl),

            // ── Danger Zone Section ───────────────────────────────────────
            Padding(
              padding: EdgeInsets.only(left: 2.w, bottom: AppSpacing.sm),
              child: Text(
                'DANGER ZONE',
                style: AppUrbanist.daysCaption(color: AppColors.error),
              ),
            ),

            // Danger Zone Card
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
                    _SecurityTile(
                      icon: Icons.delete_outline_rounded,
                      iconBg: isDark
                          ? tokens.tilePink
                          : AppColors.error.withValues(alpha: 0.12),
                      iconColor: isDark ? tokens.tilePinkIcon : AppColors.error,
                      title: 'Delete Account',
                      subtitle: 'Permanently delete your HabitFlow account',
                      titleColor: AppColors.error,
                      onTap: () => context.push(AppRoutes.deleteAccount),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Security Tile — mirrors SettingsTile design
// -----------------------------------------------------------------------------

class _SecurityTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? titleColor;

  const _SecurityTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
          child: Row(
            children: [
              // Circular accent icon badge
              Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20.sp,
                ),
              ),

              SizedBox(width: 14.w),

              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppUrbanist.body(
                        color: titleColor ?? tokens.text,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      maxLines: 2,
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

              SizedBox(width: 8.w),

              // Subtle chevron
              Icon(
                Icons.chevron_right_rounded,
                color: tokens.mutedText.withValues(alpha: 0.60),
                size: 20.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
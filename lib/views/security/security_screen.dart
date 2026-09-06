import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import '../../controllers/auth/auth_bloc.dart';
import '../../controllers/auth/auth_event.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

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
                    splashRadius: 22.r,
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: colorScheme.onSurface,
                    ),
                  ),

                  SizedBox(width: AppSpacing.md),

                  Text(
                    'Security',
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
                  'Manage your account security',
                  style: AppTextStyles.body.copyWith(
                    fontSize: 14.sp,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.xl),

              // Content
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(
                    bottom: 100.h,
                  ),
                  children: [
                    // Account Security
                    _SectionTitle(
                      title: 'ACCOUNT SECURITY',
                      color: colorScheme.primary,
                    ),

                    SizedBox(height: AppSpacing.sm),

                    _SecurityCard(
                      children: [
                        _SecurityTile(
                          icon: Icons.lock_outline_rounded,
                          title: 'Change Password',
                          subtitle: 'Update your account password',
                          onTap: () {
                            context.push(AppRoutes.changePassword);
                          },
                        ),

                        // _SecurityDivider(),
                        //
                        // _SecurityTile(
                        //   icon: Icons.mark_email_read_outlined,
                        //   title: 'Reset Password',
                        //   subtitle: 'Send a password reset email',
                        //   onTap: () {
                        //     // TODO: Implement password reset.
                        //   },
                        // ),
                      ],
                    ),

                    SizedBox(height: AppSpacing.xl),

                    // Danger Zone
                    _SectionTitle(
                      title: 'DANGER ZONE',
                      color: AppColors.error,
                    ),

                    SizedBox(height: AppSpacing.sm),

                    _SecurityCard(
                      children: [
                        _SecurityTile(
                          icon: Icons.delete_outline_rounded,
                          title: 'Delete Account',
                          subtitle:
                          'Permanently delete your HabitFlow account',
                          isDestructive: true,
                          onTap: () {
                            context.push(AppRoutes.deleteAccount);
                          },
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

// -----------------------------------------------------------------------------
// Section Title
// -----------------------------------------------------------------------------

class _SectionTitle extends StatelessWidget {
  final String title;
  final Color color;

  const _SectionTitle({
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.caption.copyWith(
        color: color,
        fontSize: 11.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Security Card
// -----------------------------------------------------------------------------

class _SecurityCard extends StatelessWidget {
  final List<Widget> children;

  const _SecurityCard({
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(
          AppRadius.lg,
        ),
        border: Border.all(
          color: colorScheme.outline.withValues(
            alpha: 0.25,
          ),
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Security Tile
// -----------------------------------------------------------------------------

class _SecurityTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SecurityTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final iconColor = isDestructive
        ? AppColors.error
        : colorScheme.primary;

    final titleColor = isDestructive
        ? AppColors.error
        : colorScheme.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          AppRadius.lg,
        ),
        child: Padding(
          padding: EdgeInsets.all(
            AppSpacing.md,
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: iconColor.withValues(
                    alpha: 0.12,
                  ),
                  borderRadius: BorderRadius.circular(
                    AppRadius.sm,
                  ),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 22.sp,
                ),
              ),

              SizedBox(width: AppSpacing.md),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.body.copyWith(
                        color: titleColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: AppSpacing.sm),

              // Arrow
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant,
                size: 22.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Divider
// -----------------------------------------------------------------------------

class _SecurityDivider extends StatelessWidget {
  const _SecurityDivider();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Divider(
      height: 1,
      thickness: 1,
      indent: 76.w,
      endIndent: AppSpacing.md,
      color: colorScheme.outline.withValues(
        alpha: 0.15,
      ),
    );
  }
}
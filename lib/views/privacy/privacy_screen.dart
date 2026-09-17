import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
                    'Privacy',
                    style: AppTextStyles.heading1.copyWith(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                      height: 1.15,
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppSpacing.xl),

              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 100.h),
                  children: [
                    _PrivacyIntro(),

                    SizedBox(height: AppSpacing.xl),

                    _PrivacySection(
                      icon: Icons.person_outline_rounded,
                      title: 'Account Information',
                      description:
                          'HabitFlow uses Firebase Authentication to securely manage your account and sign-in information.',
                    ),

                    SizedBox(height: AppSpacing.md),

                    _PrivacySection(
                      icon: Icons.storage_outlined,
                      title: 'Habit Data',
                      description:
                          'Your habit information is stored locally on your device using Hive so the app can work with your habits efficiently.',
                    ),

                    SizedBox(height: AppSpacing.md),

                    _PrivacySection(
                      icon: Icons.notifications_none_rounded,
                      title: 'Notifications',
                      description:
                          'If you enable habit reminders, HabitFlow schedules notifications on your device at the time you choose.',
                    ),

                    SizedBox(height: AppSpacing.md),

                    _PrivacySection(
                      icon: Icons.security_outlined,
                      title: 'Data Security',
                      description:
                          'HabitFlow uses the security mechanisms provided by the services it relies on. Keep your account credentials private and use a secure password.',
                    ),

                    SizedBox(height: AppSpacing.xl),

                    Container(
                      padding: EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: colorScheme.primary,
                            size: 20.sp,
                          ),
                          SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              'This information describes how the current version of HabitFlow handles your data. It may be updated as the app evolves.',
                              style: AppTextStyles.caption.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
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

class _PrivacyIntro extends StatelessWidget {
  const _PrivacyIntro();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(
              Icons.privacy_tip_outlined,
              color: colorScheme.primary,
              size: 24.sp,
            ),
          ),

          SizedBox(height: AppSpacing.md),

          Text(
            'Your privacy matters',
            style: AppTextStyles.heading2.copyWith(
              color: colorScheme.onSurface,
            ),
          ),

          SizedBox(height: AppSpacing.sm),

          Text(
            'Here is a simple overview of how HabitFlow handles the information used by the app.',
            style: AppTextStyles.bodySmall.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivacySection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _PrivacySection({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 20.sp),
          ),

          SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),

                SizedBox(height: 4.h),

                Text(
                  description,
                  style: AppTextStyles.caption.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

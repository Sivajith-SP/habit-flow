import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
                    'About HabitFlow',
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
                    // App identity
                    Container(
                      padding: EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 80.r,
                            height: 80.r,
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(
                                alpha: 0.14,
                              ),
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                            ),
                            child: Icon(
                              Icons.track_changes_rounded,
                              size: 42.sp,
                              color: colorScheme.primary,
                            ),
                          ),

                          SizedBox(height: AppSpacing.lg),

                          Text(
                            'HabitFlow',
                            style: AppTextStyles.heading2.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),

                          SizedBox(height: AppSpacing.sm),

                          Text(
                            'Build better habits, one day at a time.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSpacing.xl),

                    _AboutSection(
                      title: 'App Information',
                      children: [
                        _AboutTile(
                          icon: Icons.info_outline_rounded,
                          title: 'Version',
                          value: '1.0.0',
                        ),
                        _AboutTile(
                          icon: Icons.phone_android_rounded,
                          title: 'Platform',
                          value: 'Android',
                        ),
                      ],
                    ),

                    SizedBox(height: AppSpacing.xl),

                    _AboutSection(
                      title: 'Technology',
                      children: [
                        _AboutTile(
                          icon: Icons.flutter_dash_rounded,
                          title: 'Built with',
                          value: 'Flutter',
                        ),
                        _AboutTile(
                          icon: Icons.cloud_outlined,
                          title: 'Backend',
                          value: 'Firebase',
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

class _AboutSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _AboutSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
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
        ),

        SizedBox(height: AppSpacing.sm),

        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _AboutTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool showChevron;

  const _AboutTile({
    required this.icon,
    required this.title,
    required this.value,
    this.showChevron = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14.h),
      child: Row(
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
            child: Text(
              title,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),

          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          if (showChevron) ...[
            SizedBox(width: AppSpacing.sm),
            Icon(
              Icons.chevron_right_rounded,
              color: colorScheme.onSurfaceVariant,
              size: 20.sp,
            ),
          ],
        ],
      ),
    );
  }
}

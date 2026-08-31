import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({
    super.key,
    required this.completedHabits,
    required this.totalHabits,
    required this.weekProgress,
    required this.currentStreak,
  });

  final int completedHabits;
  final int totalHabits;
  final List<bool> weekProgress;
  final int currentStreak;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final progress = totalHabits == 0 ? 0.0 : completedHabits / totalHabits;

    final percentage = (progress * 100).toInt();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Progress",
            style: AppTextStyles.title.copyWith(
              color: colorScheme.onSurface,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 14.h),

          _WeekProgress(weekProgress: weekProgress),

          SizedBox(height: 14.h),

          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 12.h,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.45,
              ),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$completedHabits of $totalHabits habits done',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colorScheme.onSurface,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutCubic,
                      tween: Tween(begin: 0, end: percentage.toDouble()),
                      builder: (context, value, _) {
                        return Text(
                          '${value.toInt()}%',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: colorScheme.primary,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      },
                    ),
                  ],
                ),

                SizedBox(height: 10.h),

                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                  tween: Tween(begin: 0, end: progress),
                  builder: (context, value, _) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      child: LinearProgressIndicator(
                        value: value,
                        minHeight: 10.h,
                        backgroundColor: colorScheme.primary.withValues(
                          alpha: 0.15,
                        ),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.primary,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 14.h),

          Row(
            children: [
              Expanded(
                child: _StatTile(
                  icon: Icons.local_fire_department_rounded,
                  color: const Color(0xFFFF6B35),
                  value: '$currentStreak',
                  label: 'day streak',
                ),
              ),

              Container(
                width: 1,
                height: 24.h,
                color: colorScheme.outlineVariant,
              ),

              Expanded(
                child: _StatTile(
                  icon: Icons.check_circle_rounded,
                  color: colorScheme.primary,
                  value: '$completedHabits/$totalHabits',
                  label: 'completed',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeekProgress extends StatelessWidget {
  const _WeekProgress({required this.weekProgress});

  final List<bool> weekProgress;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    final today = DateTime.now().weekday - 1;

    return Row(
      children: List.generate(7, (index) {
        final completed = index < weekProgress.length && weekProgress[index];

        final isToday = index == today;
        final upcoming = index > today;

        return Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                labels[index],
                style: AppTextStyles.caption.copyWith(
                  fontSize: 12.sp,
                  fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                  color: isToday
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
              ),

              SizedBox(height: 4.h),

              Container(
                width: 26.r,
                height: 26.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: completed || isToday
                      ? colorScheme.primary
                      : upcoming
                      ? Colors.transparent
                      : colorScheme.primary.withValues(alpha: 0.15),
                  border: upcoming
                      ? Border.all(
                          color: colorScheme.outline.withValues(alpha: 0.55),
                        )
                      : null,
                ),
                child: completed || isToday
                    ? Icon(
                        Icons.check_rounded,
                        color: colorScheme.onPrimary,
                        size: 13.sp,
                      )
                    : null,
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 28.w,
          height: 28.w,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(icon, color: color, size: 14.sp),
        ),

        SizedBox(width: 6.w),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: AppTextStyles.title.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w800,
                fontSize: 14.sp,
                height: 1.1,
              ),
            ),

            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

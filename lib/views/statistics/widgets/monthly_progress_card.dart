import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';

class MonthlyProgressCard extends StatelessWidget {
  final int monthlyCompleted;
  final int monthlyTotal;

  const MonthlyProgressCard({
    super.key,
    required this.monthlyCompleted,
    required this.monthlyTotal,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final percentage = monthlyTotal == 0
        ? 0
        : ((monthlyCompleted / monthlyTotal) * 100).round();
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.35),
        ),
        boxShadow: isDark ? null : AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Progress',
            style: AppTextStyles.title.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: AppSpacing.xs),

          Text(
            'Your overall consistency this month',
            style: AppTextStyles.caption.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          SizedBox(height: AppSpacing.lg),

          Row(
            children: [
              SizedBox(
                width: 82.w,
                height: 82.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 82.w,
                      height: 82.w,
                      child: CircularProgressIndicator(
                        value: monthlyTotal == 0
                            ? 0.0
                            : (monthlyCompleted / monthlyTotal).clamp(0.0, 1.0),
                        strokeWidth: 8.w,
                        backgroundColor: colorScheme.primary.withValues(
                          alpha: 0.15,
                        ),
                        color: colorScheme.primary,
                      ),
                    ),
                    Text(
                      '$percentage%',
                      style: AppTextStyles.title.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: AppSpacing.lg),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Great progress!',
                      style: AppTextStyles.title.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      'Keep completing your habits to improve your consistency.',
                      style: AppTextStyles.caption.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

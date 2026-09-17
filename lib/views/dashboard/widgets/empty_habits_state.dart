import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';

class EmptyHabitsState extends StatelessWidget {
  const EmptyHabitsState({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg.w,
            vertical: AppSpacing.xl.h,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 320.w,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 72.r,
                      height: 72.r,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(
                          alpha: 0.12,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.task_alt_rounded,
                        color: colorScheme.primary,
                        size: 36.sp,
                      ),
                    ),

                    SizedBox(height: AppSpacing.lg.h),

                    Text(
                      'No habits for today',
                      style: AppTextStyles.heading2.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: AppSpacing.sm.h),

                    Text(
                      'Tap the + button to create your first habit and start building consistency.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
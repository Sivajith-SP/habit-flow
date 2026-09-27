import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_flow_tokens.dart';

/// Shown on the dashboard when no habits are scheduled for today.
/// Matches the reference design: lavender + icon, title, subtitle, CTA button.
class EmptyHabitsState extends StatelessWidget {
  /// Called when the user taps "Add a habit". If null, the button is still
  /// rendered but does nothing.
  final VoidCallback? onAddHabit;

  const EmptyHabitsState({super.key, this.onAddHabit});

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: isDark ? Border.all(color: tokens.border, width: 1) : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon circle
          Container(
            width: 64.r,
            height: 64.r,
            decoration: BoxDecoration(
              color: tokens.tileLavender,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.add_rounded,
                color: tokens.accent,
                size: 32.sp,
              ),
            ),
          ),

          SizedBox(height: 18.h),

          // Title
          Text(
            'No habits yet',
            style: AppUrbanist.sectionTitle(color: tokens.text).copyWith(
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 6.h),

          // Subtitle
          Text(
            'Add your first habit to start tracking.',
            textAlign: TextAlign.center,
            style: AppUrbanist.body(color: tokens.mutedText),
          ),

          SizedBox(height: 24.h),

          // CTA button
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: onAddHabit ?? () {},
              style: TextButton.styleFrom(
                backgroundColor: tokens.centerPlusBg,
                foregroundColor: tokens.centerPlusIcon,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              child: Text(
                'Add a habit',
                style: AppUrbanist.body(
                  color: tokens.centerPlusIcon,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
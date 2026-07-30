import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../onboarding_items.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingItem item;
  final double pageOffset;

  const OnboardingPage({
    super.key,
    required this.item,
    required this.pageOffset,
  });

  @override
  Widget build(BuildContext context) {
    final parallaxOffset = pageOffset * 30;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Graphic Illustration in upper center area
          Expanded(
            child: Center(
              child: Transform.translate(
                offset: Offset(parallaxOffset, 0),
                child: SizedBox(
                  height: 280.h,
                  child: Lottie.asset(
                    item.animation,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          // Bottom Left Typography Stack matching reference design exactly
          // 1. Small Uppercase Tagline
          Text(
            "GROW SOMETHING",
            style: (Theme.of(context).textTheme.bodySmall ?? AppTextStyles.caption).copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: AppColors.textSecondary,
            ),
          ),

          SizedBox(height: AppSpacing.gap10),

          // 2. Main Title (Serif look with clean line height)
          Text(
            item.title,
            style: (Theme.of(context).textTheme.displayLarge ?? AppTextStyles.heading1).copyWith(
              fontSize: 32.sp,
              fontWeight: FontWeight.w700,
              fontFamily: 'Serif',
              height: 1.15,
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: AppSpacing.gap12),

          // 3. Subtitle / Description
          Text(
            item.subtitle,
            style: (Theme.of(context).textTheme.bodyMedium ?? AppTextStyles.bodySmall).copyWith(
              fontSize: 15.sp,
              height: 1.4,
              color: AppColors.textSecondary,
            ),
          ),

        ],
      ),
    );
  }
}
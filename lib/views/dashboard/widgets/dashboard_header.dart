import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key, this.userName = "Alex"});

  final String userName;

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good morning";
    if (hour < 17) return "Good afternoon";
    return "Good evening";
  }

  String _date() {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final now = DateTime.now();
    return '${months[now.month - 1]} ${now.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left: greeting + name
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _date().toUpperCase(),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 5.h),
              // Greeting (light weight) + name (bold) — single line
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${_greeting()}, ",
                      style: AppTextStyles.heading1.copyWith(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                        height: 1.15,
                      ),
                    ),
                    TextSpan(
                      text: "$userName.",
                      style: AppTextStyles.heading1.copyWith(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: AppSpacing.md),

        Container(
          width: 46.r,
          height: 46.r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            color: AppColors.primaryLight.withValues(alpha: .55),
            border: Border.all(color: AppColors.primary.withValues(alpha: .08)),
          ),
          child: Center(
            child: Text(
              userName.isNotEmpty ? userName[0].toUpperCase() : "A",
              style: AppTextStyles.title.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

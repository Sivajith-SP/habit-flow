import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    this.userName = "Alex",
  });

  final String userName;

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good morning";
    if (hour < 17) return "Good afternoon";
    return "Good evening";
  }

  String _date() {
    const weekdays = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];

    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    final now = DateTime.now();
    return "${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left: date chip + greeting + name
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subtle date pill badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  _date().toUpperCase(),
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                    color: AppColors.primary,
                  ),
                ),
              ),

              SizedBox(height: 8.h),

              // Greeting (light weight) + name (bold) — single line
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${_greeting()}, ",
                      style: AppTextStyles.heading1.copyWith(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                        height: 1.15,
                      ),
                    ),
                    TextSpan(
                      text: "$userName.",
                      style: AppTextStyles.heading1.copyWith(
                        fontSize: 22.sp,
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

        // Minimal letter avatar
        Container(
          width: 42.r,
          height: 42.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryLight.withValues(alpha: 0.6),
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
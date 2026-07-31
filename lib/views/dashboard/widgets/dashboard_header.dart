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

    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _greeting(),
                style: AppTextStyles.heading1.copyWith(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.05,
                  color: AppColors.textPrimary,
                ),
              ),

              SizedBox(height: 2.h),

              Text(
                userName,
                style: AppTextStyles.body.copyWith(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                  height: 1.2,
                ),
              ),

              SizedBox(height: 10.h),

              Text(
                _date(),
                style: AppTextStyles.caption.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                  color: AppColors.textSecondary.withValues(alpha: 0.75),
                ),
              ),

            ],
          ),
        ),

        CircleAvatar(
          radius: 26.r,
          backgroundColor: AppColors.primaryLight,
          child: Icon(
            Icons.person_rounded,
            color: AppColors.primary,
            size: 28.sp,
          ),
        ),
      ],
    );
  }
}
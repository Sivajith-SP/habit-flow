import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _date().toUpperCase(),
                style: AppTextStyles.caption.copyWith(
                  color: colorScheme.primary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),

              SizedBox(height: 5.h),

              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${_greeting()}, ",
                      style: AppTextStyles.heading1.copyWith(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w400,
                        color: colorScheme.onSurfaceVariant,
                        height: 1.15,
                      ),
                    ),

                    TextSpan(
                      text: "$userName.",
                      style: AppTextStyles.heading1.copyWith(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
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
            color: colorScheme.primary.withValues(alpha: 0.15),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.15),
            ),
          ),
          child: Center(
            child: Text(
              userName.isNotEmpty
                  ? userName[0].toUpperCase()
                  : "A",
              style: AppTextStyles.title.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: colorScheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
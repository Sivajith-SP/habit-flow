import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';

class WeekCalendar extends StatelessWidget {
  const WeekCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    const days = [
      ("Sun", "27"),
      ("Mon", "28"),
      ("Tue", "29"),
      ("Wed", "30"),
      ("Thu", "31"),
      ("Fri", "1"),
      ("Sat", "2"),
    ];

    const selectedIndex = 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "This Week",
          style: AppTextStyles.title,
        ),

        SizedBox(height: AppSpacing.md),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            days.length,
                (index) {
              final item = days[index];
              final selected = index == selectedIndex;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary
                          : Colors.white.withValues(alpha: .55),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Column(
                      children: [
                        Text(
                          item.$1,
                          style: AppTextStyles.caption.copyWith(
                            color: selected
                                ? Colors.white70
                                : AppColors.textSecondary,
                          ),
                        ),

                        SizedBox(height: 8.h),

                        Text(
                          item.$2,
                          style: AppTextStyles.title.copyWith(
                            color: selected
                                ? Colors.white
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
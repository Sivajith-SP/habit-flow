import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_flow_tokens.dart';

/// Full-width amber banner pill showing current streak with dynamic copy.
class StreakCard extends StatelessWidget {
  final int currentStreak;

  const StreakCard({super.key, required this.currentStreak});

  String _subtitle() {
    if (currentStreak == 0) return 'Start your streak today!';
    if (currentStreak < 7) return 'Keep building your consistency';
    if (currentStreak < 30) return 'One week strong! 🎉';
    return 'Incredible dedication! 🏆';
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;

    return Container(
      height: 80.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: tokens.tileButter,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          // Flame icon circle
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: tokens.tileButterIcon.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.local_fire_department_rounded,
                color: tokens.tileButterIcon,
                size: 26.sp,
              ),
            ),
          ),

          SizedBox(width: 14.w),

          // Title + subtitle
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Streak',
                  style: AppUrbanist.body(
                    color: tokens.tileButterIcon,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  _subtitle(),
                  style: AppUrbanist.body(
                    color: tokens.tileButterIcon.withValues(alpha: 0.75),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          SizedBox(width: 8.w),

          // Large streak count
          Text(
            '$currentStreak ${currentStreak == 1 ? 'day' : 'days'}',
            style: AppUrbanist.body(
              color: tokens.tileButterIcon,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
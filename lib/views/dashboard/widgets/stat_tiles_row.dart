import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_flow_tokens.dart';
import '../../../app/theme/app_radius.dart';

class StatTilesRow extends StatelessWidget {
  const StatTilesRow({
    super.key,
    required this.currentStreak,
    required this.completedHabits,
    required this.totalHabits,
  });

  final int currentStreak;
  final int completedHabits;
  final int totalHabits;

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        // Streak Tile (tileButter)
        Expanded(
          child: Container(
            constraints: BoxConstraints(minHeight: 120.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: tokens.tileButter,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              boxShadow: isDark ? null : tokens.cardShadow,
              border: isDark ? Border.all(color: tokens.border, width: 1) : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 40px round icon chip
                Container(
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: tokens.raised.withValues(alpha: isDark ? 0.25 : 0.5),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.local_fire_department_rounded,
                      color: tokens.tileButterIcon,
                      size: 20.sp,
                    ),
                  ),
                ),

                SizedBox(height: 10.h),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '$currentStreak',
                        style: AppUrbanist.statNumber(color: tokens.text),
                      ),
                    ),
                    Text(
                      'day streak',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppUrbanist.body(
                        color: tokens.text.withValues(alpha: 0.8),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        SizedBox(width: 12.w),

        // Completed Tile (tileMint)
        Expanded(
          child: Container(
            constraints: BoxConstraints(minHeight: 120.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: tokens.tileMint,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              boxShadow: isDark ? null : tokens.cardShadow,
              border: isDark ? Border.all(color: tokens.border, width: 1) : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 40px round icon chip
                Container(
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: tokens.raised.withValues(alpha: isDark ? 0.25 : 0.5),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check_circle_outline_rounded,
                      color: tokens.tileMintIcon,
                      size: 20.sp,
                    ),
                  ),
                ),

                SizedBox(height: 10.h),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '$completedHabits/$totalHabits',
                        style: AppUrbanist.statNumber(color: tokens.text),
                      ),
                    ),
                    Text(
                      'completed',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppUrbanist.body(
                        color: tokens.text.withValues(alpha: 0.8),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

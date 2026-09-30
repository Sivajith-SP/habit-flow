import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_flow_tokens.dart';

/// Monthly consistency card with a circular progress ring and dynamic headline.
class MonthlyProgressCard extends StatelessWidget {
  final int monthlyCompleted;
  final int monthlyTotal;

  const MonthlyProgressCard({
    super.key,
    required this.monthlyCompleted,
    required this.monthlyTotal,
  });

  int get _pct => monthlyTotal == 0
      ? 0
      : ((monthlyCompleted / monthlyTotal) * 100).round();

  String _headline() {
    final p = _pct;
    if (p == 0) return 'Just getting started';
    if (p <= 40) return 'Building momentum';
    if (p <= 70) return 'Great progress!';
    if (p < 100) return 'Almost there! 🔥';
    return 'Perfect month! 🏆';
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final progressValue = monthlyTotal == 0
        ? 0.0
        : (monthlyCompleted / monthlyTotal).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: isDark ? Border.all(color: tokens.border, width: 1) : null,
        boxShadow: isDark ? null : tokens.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Monthly Progress',
            style: AppUrbanist.body(
              color: tokens.text,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Your overall consistency this month',
            style: AppUrbanist.body(color: tokens.mutedText, fontSize: 13),
          ),

          SizedBox(height: 20.h),

          Row(
            children: [
              // Ring
              SizedBox(
                width: 88.w,
                height: 88.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 88.w,
                      height: 88.w,
                      child: CircularProgressIndicator(
                        value: progressValue,
                        strokeWidth: 10.w,
                        strokeCap: StrokeCap.round,
                        backgroundColor: tokens.field,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(tokens.accent),
                      ),
                    ),
                    Text(
                      '$_pct%',
                      style: AppUrbanist.body(
                        color: tokens.accent,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 20.w),

              // Insight text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _headline(),
                      style: AppUrbanist.body(
                        color: tokens.text,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      '$monthlyCompleted of $monthlyTotal habits this month',
                      style: AppUrbanist.body(
                        color: tokens.mutedText,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: LinearProgressIndicator(
                        value: progressValue,
                        minHeight: 6.h,
                        backgroundColor: tokens.field,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(tokens.accent),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

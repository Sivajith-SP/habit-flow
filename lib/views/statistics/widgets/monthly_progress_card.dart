import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_flow_tokens.dart';

/// Monthly consistency card — reference-image redesign.
/// Lavender-tinted card, top-row label + streak pill, circular ring,
/// insight text, and full-width linear progress bar.
class MonthlyProgressCard extends StatelessWidget {
  final int monthlyCompleted;
  final int monthlyTotal;
  final int currentStreak;

  const MonthlyProgressCard({
    super.key,
    required this.monthlyCompleted,
    required this.monthlyTotal,
    required this.currentStreak,
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

    final cardBg = tokens.tileLavender;
    final accentColor = tokens.tileLavenderIcon;
    final ringBg = accentColor.withValues(alpha: isDark ? 0.18 : 0.14);

    final progressValue = monthlyTotal == 0
        ? 0.0
        : (monthlyCompleted / monthlyTotal).clamp(0.0, 1.0);

    // Ring size: 80.w but cap at 88 logical px so narrow screens aren't dominated
    final ringSize = (80.w).clamp(0.0, 88.0);

    return Container(
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 18.h),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row: label + streak badge ──────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Flexible so it shrinks before the pill overflows
              Flexible(
                child: Text(
                  'Monthly progress',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppUrbanist.body(
                    color: accentColor.withValues(alpha: 0.75),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              // Streak pill badge — flex: 0 so it stays compact
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: tokens.surface,
                  borderRadius: BorderRadius.circular(50.r),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.10),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '🔥',
                      style: TextStyle(fontSize: 13.sp),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      '$currentStreak day${currentStreak == 1 ? '' : 's'} streak',
                      style: AppUrbanist.body(
                        color: tokens.text,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // ── Ring + insight text ────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circular ring — size clamped so it doesn't dominate narrow screens
              SizedBox(
                width: ringSize,
                height: ringSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: ringSize,
                      height: ringSize,
                      child: CircularProgressIndicator(
                        value: progressValue,
                        strokeWidth: (ringSize * 0.11).clamp(7.0, 11.0),
                        strokeCap: StrokeCap.round,
                        backgroundColor: ringBg,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(accentColor),
                      ),
                    ),
                    Text(
                      '$_pct%',
                      style: AppUrbanist.body(
                        color: accentColor,
                        fontSize: (ringSize * 0.22).clamp(14.0, 18.0),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 16.w),

              // Insight text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _headline(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppUrbanist.body(
                        color: accentColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      '$monthlyCompleted of $monthlyTotal habits this month. Keep completing your habits to improve your consistency.',
                      style: AppUrbanist.body(
                        color: accentColor.withValues(alpha: 0.75),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
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

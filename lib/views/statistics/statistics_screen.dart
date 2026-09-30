import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/theme/app_flow_tokens.dart';
import '../../controllers/statistics/statistics_bloc.dart';
import '../../controllers/statistics/statistics_state.dart';
import 'widgets/monthly_progress_card.dart';
import 'widgets/statistics_overview_card.dart';
import 'widgets/streak_card.dart';
import 'widgets/weekly_progress_card.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  String _monthLabel() {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    final now = DateTime.now();
    return '${months[now.month - 1]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;

    return ColoredBox(
      color: tokens.background,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ───────────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Statistics',
                          style: AppUrbanist.sheetTitle(color: tokens.text),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Track your habit progress',
                          style: AppUrbanist.body(color: tokens.mutedText),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _monthLabel(),
                    style: AppUrbanist.body(
                      color: tokens.mutedText,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // ── Scrollable body with top-edge alpha fade ──────────────────────
            Expanded(
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  // Fade the top 24 logical pixels of the scroll area to
                  // transparent — content that scrolls into this zone
                  // dissolves rather than being hard-clipped.
                  const fadeHeight = 24.0;
                  final stop =
                      (fadeHeight / bounds.height).clamp(0.01, 0.12);
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: const [Colors.transparent, Colors.black],
                    stops: [0.0, stop],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: BlocBuilder<StatisticsBloc, StatisticsState>(
                  builder: (context, state) {
                    if (state is StatisticsLoading ||
                        state is StatisticsInitial) {
                      return const _LoadingSkeleton();
                    }
                    if (state is StatisticsError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: AppUrbanist.body(color: tokens.mutedText),
                        ),
                      );
                    }
                    if (state is StatisticsLoaded) {
                      return _StatisticsBody(state: state);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Body — all cards
// ─────────────────────────────────────────────────────────────────────────────

class _StatisticsBody extends StatelessWidget {
  final StatisticsLoaded state;

  const _StatisticsBody({required this.state});

  @override
  Widget build(BuildContext context) {
    final systemBottom = MediaQuery.of(context).viewPadding.bottom;
    final listBottom = 74.h + 24.h + systemBottom + 16.h;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, listBottom),
      children: [
        // 1. KPI tiles
        StatisticsOverviewCard(
          completedToday: state.completedToday,
          totalHabits: state.totalHabits,
          currentStreak: state.currentStreak,
        ),

        SizedBox(height: 16.h),

        // 2. Monthly ring
        MonthlyProgressCard(
          monthlyCompleted: state.monthlyCompleted,
          monthlyTotal: state.monthlyTotal,
        ),

        SizedBox(height: 16.h),

        // 3. Weekly bar chart
        WeeklyProgressCard(weeklyProgress: state.weeklyProgress),

        SizedBox(height: 16.h),

        // 4. Streak banner
        StreakCard(currentStreak: state.currentStreak),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Loading skeleton
// ─────────────────────────────────────────────────────────────────────────────

class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final systemBottom = MediaQuery.of(context).viewPadding.bottom;
    final listBottom = 74.h + 24.h + systemBottom + 16.h;

    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, listBottom),
      children: [
        Row(
          children: List.generate(
            3,
            (i) => Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i < 2 ? 10.w : 0),
                height: 88.h,
                decoration: BoxDecoration(
                  color: tokens.field,
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          height: 140.h,
          decoration: BoxDecoration(
            color: tokens.field,
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          height: 220.h,
          decoration: BoxDecoration(
            color: tokens.field,
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          height: 72.h,
          decoration: BoxDecoration(
            color: tokens.field,
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
      ],
    );
  }
}

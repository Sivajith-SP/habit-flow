import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/theme/app_flow_tokens.dart';
import '../../controllers/statistics/statistics_bloc.dart';
import '../../controllers/statistics/statistics_state.dart';
import '../common/frosted_scroll_header.dart';
import 'widgets/monthly_progress_card.dart';
import 'widgets/statistics_overview_card.dart';
import 'widgets/streak_card.dart';
import 'widgets/weekly_progress_card.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final _scrollController = ScrollController();

  String _monthLabel() {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    final now = DateTime.now();
    return '${months[now.month - 1]} ${now.year}';
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final statusBarHeight = MediaQuery.of(context).padding.top;
    final systemBottom = MediaQuery.of(context).viewPadding.bottom;
    final listBottom = 74.h + 24.h + systemBottom + 16.h;

    // Header metrics: 12.h + ~30.h + 2.h + ~18.h + 10.h => ~72.h
    // plus gap14: 14.h => 86.h
    final headerContentHeight = 72.h;
    final listTopPadding = statusBarHeight + headerContentHeight + 14.h;

    Widget headerWidget = SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 10.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
            // Month pill badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
              decoration: BoxDecoration(
                color: isDark ? tokens.raised : tokens.surface,
                borderRadius: BorderRadius.circular(50.r),
                boxShadow: isDark ? null : tokens.cardShadow,
                border: isDark
                    ? Border.all(color: tokens.border, width: 1)
                    : null,
              ),
              child: Text(
                _monthLabel(),
                style: AppUrbanist.body(
                  color: tokens.text,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return ColoredBox(
      color: tokens.background,
      child: Stack(
        children: [
          // ── Scrollable body ────────────────────────────────────────
          BlocBuilder<StatisticsBloc, StatisticsState>(
            builder: (context, state) {
              if (state is StatisticsLoading ||
                  state is StatisticsInitial) {
                return _LoadingSkeleton(
                  scrollController: _scrollController,
                  topPadding: listTopPadding,
                  bottomPadding: listBottom,
                );
              }
              if (state is StatisticsError) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: listTopPadding),
                    child: Text(
                      state.message,
                      style: AppUrbanist.body(color: tokens.mutedText),
                    ),
                  ),
                );
              }
              if (state is StatisticsLoaded) {
                return _StatisticsBody(
                  state: state,
                  scrollController: _scrollController,
                  topPadding: listTopPadding,
                  bottomPadding: listBottom,
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // ── Frosted glass header overlay ─────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: FrostedScrollHeader(
              controller: _scrollController,
              child: headerWidget,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Body — all cards
// ─────────────────────────────────────────────────────────────────────────────

class _StatisticsBody extends StatelessWidget {
  final StatisticsLoaded state;
  final ScrollController scrollController;
  final double topPadding;
  final double bottomPadding;

  const _StatisticsBody({
    required this.state,
    required this.scrollController,
    required this.topPadding,
    required this.bottomPadding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20.w, topPadding, 20.w, bottomPadding),
      children: [
        // 1. Monthly ring card (includes streak badge inside)
        MonthlyProgressCard(
          monthlyCompleted: state.monthlyCompleted,
          monthlyTotal: state.monthlyTotal,
          currentStreak: state.currentStreak,
        ),

        SizedBox(height: 14.h),

        // 2. KPI tiles (Completion + Completed)
        StatisticsOverviewCard(
          completedToday: state.completedToday,
          totalHabits: state.totalHabits,
          currentStreak: state.currentStreak,
        ),

        SizedBox(height: 14.h),

        // 3. Weekly bar chart
        WeeklyProgressCard(weeklyProgress: state.weeklyProgress),

        SizedBox(height: 14.h),

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
  final ScrollController scrollController;
  final double topPadding;
  final double bottomPadding;

  const _LoadingSkeleton({
    required this.scrollController,
    required this.topPadding,
    required this.bottomPadding,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;

    return ListView(
      controller: scrollController,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20.w, topPadding, 20.w, bottomPadding),
      children: [
        // Monthly card skeleton
        Container(
          height: 160.h,
          decoration: BoxDecoration(
            color: tokens.field,
            borderRadius: BorderRadius.circular(24.r),
          ),
        ),
        SizedBox(height: 14.h),
        // 2-tile overview skeleton
        Row(
          children: List.generate(
            2,
            (i) => Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i < 1 ? 12.w : 0),
                height: 96.h,
                decoration: BoxDecoration(
                  color: tokens.field,
                  borderRadius: BorderRadius.circular(22.r),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 14.h),
        // Weekly chart skeleton
        Container(
          height: 220.h,
          decoration: BoxDecoration(
            color: tokens.field,
            borderRadius: BorderRadius.circular(24.r),
          ),
        ),
        SizedBox(height: 14.h),
        // Streak banner skeleton
        Container(
          height: 80.h,
          decoration: BoxDecoration(
            color: tokens.field,
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
      ],
    );
  }
}

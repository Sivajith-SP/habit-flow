import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitflow/views/statistics/widgets/monthly_progress_card.dart';
import 'package:habitflow/views/statistics/widgets/statistics_overview_card.dart';
import 'package:habitflow/views/statistics/widgets/streak_card.dart';
import 'package:habitflow/views/statistics/widgets/weekly_progress_card.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import '../../controllers/statistics/statistics_bloc.dart';
import '../../controllers/statistics/statistics_state.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Statistics', style: AppTextStyles.heading2),

              SizedBox(height: AppSpacing.xs),

              Text(
                'Track your habit progress',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              SizedBox(height: AppSpacing.xl),

              Expanded(
                child: ListView(
                  children: [
                    BlocBuilder<StatisticsBloc, StatisticsState>(
                      builder: (context, state) {
                        if (state is StatisticsLoaded) {
                          return StatisticsOverviewCard(
                            completedToday: state.completedToday,
                            totalHabits: state.totalHabits,
                            currentStreak: state.currentStreak,
                          );
                        }

                        if (state is StatisticsError) {
                          return Text(state.message, style: AppTextStyles.body);
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                    SizedBox(height: AppSpacing.lg),
                    BlocBuilder<StatisticsBloc, StatisticsState>(
                      builder: (context, state) {
                        if (state is StatisticsLoaded) {
                          return WeeklyProgressCard(
                            weeklyProgress: state.weeklyProgress,
                          );
                        }

                        if (state is StatisticsError) {
                          return Text(state.message, style: AppTextStyles.body);
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                    SizedBox(height: AppSpacing.lg),
                    BlocBuilder<StatisticsBloc, StatisticsState>(
                      builder: (context, state) {
                        if (state is StatisticsLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state is StatisticsLoaded) {
                          return StreakCard(currentStreak: state.currentStreak);
                        }

                        if (state is StatisticsError) {
                          return Text(state.message, style: AppTextStyles.body);
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                    SizedBox(height: AppSpacing.lg),
                    BlocBuilder<StatisticsBloc, StatisticsState>(
                      builder: (context, state) {
                        if (state is StatisticsLoaded) {
                          return MonthlyProgressCard(
                            monthlyCompleted: state.monthlyCompleted,
                            monthlyTotal: state.monthlyTotal,
                          );
                        }

                        if (state is StatisticsError) {
                          return Text(state.message, style: AppTextStyles.body);
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

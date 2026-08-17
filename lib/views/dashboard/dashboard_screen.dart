import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:habitflow/views/dashboard/widgets/empty_habits_state.dart';
import 'package:habitflow/views/dashboard/widgets/habits_loading_state.dart';
import 'package:habitflow/views/dashboard/widgets/progress_card.dart';
import 'package:habitflow/views/dashboard/widgets/todays_habits_section.dart';

import '../../app/router/app_routes.dart';
import '../../app/theme/app_spacing.dart';
import '../../controllers/auth/auth_bloc.dart';
import '../../controllers/auth/auth_state.dart';
import '../../controllers/habits/habits_bloc.dart';
import '../../controllers/habits/habits_event.dart';
import '../../controllers/habits/habits_state.dart';
import '../../models/habit/habit_frequency.dart';
import 'widgets/add_habit_bottom_sheet.dart';
import 'widgets/dashboard_header.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? _selectedHabitId;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          context.go(AppRoutes.login);
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (_selectedHabitId != null) {
            setState(() {
              _selectedHabitId = null;
            });
          }
        },
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),

                  // Fixed Top Header
                  const DashboardHeader(),

                  SizedBox(height: 18.h),

                  // Fixed Progress Card
                  BlocBuilder<HabitsBloc, HabitsState>(
                    builder: (context, state) {
                      if (state is HabitsLoaded) {
                        return ProgressCard(
                          completedHabits: state.completedToday,
                          totalHabits: state.totalHabits,
                          weekProgress: state.weekProgress,
                          currentStreak: state.currentStreak,
                        );
                      }

                      return const ProgressCard(
                        completedHabits: 0,
                        totalHabits: 0,
                        weekProgress: [
                          false,
                          false,
                          false,
                          false,
                          false,
                          false,
                          false,
                        ],
                        currentStreak: 0,
                      );
                    },
                  ),

                  SizedBox(height: 22.h),

                  // Scrollable Habit Cards Section
                  Expanded(
                    child: BlocBuilder<HabitsBloc, HabitsState>(
                      builder: (context, state) {
                        if (state is HabitsLoading) {
                          return const HabitsLoadingState();
                        }

                        if (state is HabitsLoaded) {
                          final todayWeekday =
                              (DateTime.now().weekday - 1); // 0 = Mon, 6 = Sun
                          final activeHabits = state.habits.where((
                            habitWithComp,
                          ) {
                            final h = habitWithComp.habit;
                            if (h.isArchived) return false;

                            switch (h.frequency) {
                              case HabitFrequency.daily:
                                return true;
                              case HabitFrequency.weekly:
                                // If weekly and targetDays specified, check if today is selected
                                if (h.targetDays.isNotEmpty) {
                                  return h.targetDays.contains(todayWeekday);
                                }
                                // Default weekly: scheduled on the weekday it was created
                                final createdWeekday =
                                    (h.createdAt.weekday - 1);
                                return todayWeekday == createdWeekday;
                              case HabitFrequency.custom:
                                return h.targetDays.contains(todayWeekday);
                            }
                          }).toList();

                          if (activeHabits.isEmpty) {
                            return const EmptyHabitsState();
                          }

                          return TodaysHabitsSection(
                            habits: activeHabits,
                            selectedHabitId: _selectedHabitId,
                            onHabitTap: (habit) {
                              context.read<HabitsBloc>().add(
                                ToggleHabitCompletion(habit),
                              );
                            },
                            onHabitLongPress: (habit) {
                              setState(() {
                                _selectedHabitId = habit.id;
                              });
                            },
                            onEditHabit: (habit) async {
                              await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => BlocProvider.value(
                                  value: context.read<HabitsBloc>(),
                                  child: AddHabitBottomSheet(habit: habit),
                                ),
                              );

                              setState(() {
                                _selectedHabitId = null;
                              });
                            },
                          );
                        }

                        if (state is HabitsError) {
                          return Center(child: Text(state.message));
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

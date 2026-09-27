import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../app/config/service_locator.dart';
import '../../app/router/app_routes.dart';
import '../../app/theme/app_flow_tokens.dart';
import '../../controllers/auth/auth_bloc.dart';
import '../../controllers/auth/auth_state.dart';
import '../../controllers/habits/habits_bloc.dart';
import '../../controllers/habits/habits_event.dart';
import '../../controllers/habits/habits_state.dart';
import '../../repositories/auth/auth_repository.dart';
import 'widgets/add_habit_bottom_sheet.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/empty_habits_state.dart';
import 'widgets/habits_loading_state.dart';
import 'widgets/main_progress_card.dart';
import 'widgets/todays_habits_section.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? _selectedHabitId;

  /// Exposed to the habits section below so it can react to past-day
  /// selection (show a summary instead of editable habits).
  late final ValueNotifier<DateTime> _selectedDayNotifier;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDayNotifier =
        ValueNotifier(DateTime(now.year, now.month, now.day));
  }

  @override
  void dispose() {
    _selectedDayNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;

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
        child: ColoredBox(
          color: tokens.background,
          child: SafeArea(
            bottom: false,
            child: BlocBuilder<HabitsBloc, HabitsState>(
              builder: (context, habitsState) {
                // Extract metrics from HabitsState
                final int completedToday =
                    habitsState is HabitsLoaded ? habitsState.completedToday : 0;
                final int totalHabits =
                    habitsState is HabitsLoaded ? habitsState.totalHabits : 0;

                return ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 140.h),
                  children: [
                    // 1. Top Bar & 2. Greeting
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, authState) {
                        final authRepository = getIt<AuthRepository>();
                        final repositoryName =
                            authRepository.currentUserDisplayName?.trim();

                        String fullName = 'Sivajith';
                        if (authState is AuthSuccess &&
                            authState.userName.trim().isNotEmpty) {
                          fullName = authState.userName.trim();
                        } else if (repositoryName != null &&
                            repositoryName.isNotEmpty) {
                          fullName = repositoryName;
                        }

                        // Extract only the first word (first name)
                        final parts = fullName.split(RegExp(r'\s+'));
                        final userName =
                            (parts.isNotEmpty && parts.first.isNotEmpty)
                                ? parts.first
                                : 'Sivajith';

                        return DashboardHeader(
                          userName: userName,
                          completedHabits: completedToday,
                          totalHabits: totalHabits,
                        );
                      },
                    ),

                    SizedBox(height: 20.h),

                    // 3. MainProgressCard (replaces ProgressCard + StatTilesRow)
                    MainProgressCard(
                      habitsState: habitsState,
                      selectedDayNotifier: _selectedDayNotifier,
                    ),

                    SizedBox(height: 24.h),

                    // 4. Today's Habits Section & 5. Completed Section
                    _buildHabitsSection(habitsState),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHabitsSection(HabitsState state) {
    if (state is HabitsLoading) {
      return const HabitsLoadingState();
    }

    if (state is HabitsLoaded) {
      final now = DateTime.now();
      final activeHabits = state.habits.where((habitWithComp) {
        return habitWithComp.habit.isScheduledOn(now);
      }).toList();

      if (activeHabits.isEmpty) {
        return EmptyHabitsState(
          onAddHabit: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => BlocProvider.value(
              value: context.read<HabitsBloc>(),
              child: const AddHabitBottomSheet(),
            ),
          ),
        );
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
      final tokens = context.flowTokens;
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: Text(
            state.message,
            style: AppUrbanist.body(color: tokens.mutedText),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

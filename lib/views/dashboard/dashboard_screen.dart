import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final habitsBloc = context.read<HabitsBloc>();

            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => BlocProvider.value(
                value: habitsBloc,
                child: const AddHabitBottomSheet(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (_selectedHabitId != null) {
              setState(() {
                _selectedHabitId = null;
              });
            }
          },
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: TextButton.icon(
                  //     onPressed: () {
                  //       context.read<AuthBloc>().add(const LogoutRequested());
                  //     },
                  //     icon: const Icon(Icons.logout_rounded),
                  //     label: const Text("Logout"),
                  //   ),
                  // ),
                  const DashboardHeader(),

                  SizedBox(height: AppSpacing.xl),

                  const ProgressCard(),

                  SizedBox(height: AppSpacing.xl),

                  BlocBuilder<HabitsBloc, HabitsState>(
                    builder: (context, state) {
                      if (state is HabitsLoading) {
                        return const HabitsLoadingState();
                      }

                      if (state is HabitsLoaded) {
                        if (state.habits.isEmpty) {
                          return const EmptyHabitsState();
                        }

                        return TodaysHabitsSection(
                          habits: state.habits,

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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

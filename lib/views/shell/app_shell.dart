import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controllers/habits/habits_bloc.dart';
import '../dashboard/dashboard_screen.dart';
import '../dashboard/widgets/add_habit_bottom_sheet.dart';
import '../habits/habit_screen.dart';
import '../settings/settings_screen.dart';
import '../statistics/statistics_screen.dart';
import 'bottom_nav_bar.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  final _screens = const [
    DashboardScreen(),
    HabitsScreen(),
    StatisticsScreen(),
    SettingsScreen(),
  ];

  void _openAddHabitSheet() {
    final habitsBloc = context.read<HabitsBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 350),
      ),
      builder: (_) => BlocProvider.value(
        value: habitsBloc,
        child: const AddHabitBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        onAddTap: _openAddHabitSheet,
      ),
    );
  }
}

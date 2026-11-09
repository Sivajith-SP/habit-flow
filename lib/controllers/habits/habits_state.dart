import 'package:equatable/equatable.dart';
import 'package:habitflow/models/habit/habit_with_completion.dart';

abstract class HabitsState extends Equatable {
  const HabitsState();

  @override
  List<Object?> get props => [];
}

class HabitsInitial extends HabitsState {
  const HabitsInitial();
}

class HabitsLoading extends HabitsState {
  const HabitsLoading();
}

class HabitsLoaded extends HabitsState {
  final List<HabitWithCompletion> habits;

  final int completedToday;
  final int totalHabits;

  final List<bool> weekProgress;

  final int currentStreak;

  final List<int> weekDailyCompletions;
  final List<int> weekDailyTotals;

  const HabitsLoaded({
    required this.habits,
    required this.completedToday,
    required this.totalHabits,
    required this.weekProgress,
    required this.currentStreak,
    this.weekDailyCompletions = const [],
    this.weekDailyTotals = const [],
  });

  @override
  List<Object> get props => [
    habits,
    completedToday,
    totalHabits,
    weekProgress,
    currentStreak,
    weekDailyCompletions,
    weekDailyTotals,
  ];
}

class HabitsError extends HabitsState {
  final String message;

  const HabitsError(this.message);

  @override
  List<Object?> get props => [message];
}

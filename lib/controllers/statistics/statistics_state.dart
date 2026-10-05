import 'package:equatable/equatable.dart';

abstract class StatisticsState extends Equatable {
  const StatisticsState();

  @override
  List<Object?> get props => [];
}

class StatisticsInitial extends StatisticsState {
  const StatisticsInitial();
}

class StatisticsLoading extends StatisticsState {
  const StatisticsLoading();
}

class StatisticsLoaded extends StatisticsState {
  final int currentStreak;
  final List<bool> weeklyProgress;
  final List<int> dailyCompletions;
  final List<int> dailyTotals;
  final int completedToday;
  final int totalHabits;
  final int monthlyCompleted;
  final int monthlyTotal;

  const StatisticsLoaded({
    required this.currentStreak,
    required this.weeklyProgress,
    this.dailyCompletions = const [],
    this.dailyTotals = const [],
    required this.completedToday,
    required this.totalHabits,
    required this.monthlyCompleted,
    required this.monthlyTotal,
  });

  @override
  List<Object?> get props => [
    currentStreak,
    weeklyProgress,
    dailyCompletions,
    dailyTotals,
    completedToday,
    totalHabits,
    monthlyCompleted,
    monthlyTotal,
  ];
}

class StatisticsError extends StatisticsState {
  final String message;

  const StatisticsError(this.message);

  @override
  List<Object?> get props => [message];
}

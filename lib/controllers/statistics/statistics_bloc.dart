import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/habits/completion_repository.dart';
import '../../repositories/habits/habit_repository.dart';
import 'statistics_event.dart';
import 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final CompletionRepository _completionRepository;
  final HabitRepository _habitRepository;

  StatisticsBloc(this._completionRepository, this._habitRepository)
    : super(const StatisticsInitial()) {
    on<LoadStatistics>(_onLoadStatistics);
  }

  Future<void> _onLoadStatistics(
    LoadStatistics event,
    Emitter<StatisticsState> emit,
  ) async {
    emit(const StatisticsLoading());

    try {
      final currentStreak = await _completionRepository.getCurrentStreak();

      final weeklyProgress = await _completionRepository
          .getCurrentWeekProgress();

      final habits = await _habitRepository.getHabits();

      final activeHabits = habits.where((habit) => !habit.isArchived).toList();

      final monthlyCompleted = await _completionRepository
          .getMonthlyCompleted();

      final monthlyTotal = await _habitRepository.getMonthlyScheduledCount();

      int completedToday = 0;

      for (final habit in activeHabits) {
        final completed = await _completionRepository.isCompleted(
          habitId: habit.id,
          date: DateTime.now(),
        );

        if (completed) {
          completedToday++;
        }
      }

      emit(
        StatisticsLoaded(
          currentStreak: currentStreak,
          weeklyProgress: weeklyProgress,
          completedToday: completedToday,
          totalHabits: activeHabits.length,
          monthlyCompleted: monthlyCompleted,
          monthlyTotal: monthlyTotal,
        ),
      );
    } catch (e) {
      emit(StatisticsError(e.toString()));
    }
  }
}

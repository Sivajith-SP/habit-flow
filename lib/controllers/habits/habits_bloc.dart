import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/habit/habit_with_completion.dart';
import '../../repositories/habits/completion_repository.dart';
import '../../repositories/habits/habit_repository.dart';
import 'habits_event.dart';
import 'habits_state.dart';

class HabitsBloc extends Bloc<HabitsEvent, HabitsState> {
  final HabitRepository _repository;
  final CompletionRepository _completionRepository;

  HabitsBloc(this._repository,this._completionRepository) : super(const HabitsInitial()) {
    on<LoadHabits>(_onLoadHabits);
    on<AddHabit>(_onAddHabit);
    on<UpdateHabit>(_onUpdateHabit);
    on<DeleteHabit>(_onDeleteHabit);
    on<ArchiveHabit>(_onArchiveHabit);
    on<ToggleHabitCompletion>(_onToggleHabitCompletion);
  }

  Future<void> _onLoadHabits(
      LoadHabits event,
      Emitter<HabitsState> emit,
      ) async {
    emit(const HabitsLoading());

    try {
      final habits = await _repository.getHabits();

      final habitsWithCompletion = <HabitWithCompletion>[];

      for (final habit in habits) {
        final completed = await _completionRepository.isCompleted(
          habitId: habit.id,
          date: DateTime.now(),
        );

        habitsWithCompletion.add(
          HabitWithCompletion(
            habit: habit,
            isCompletedToday: completed,
          ),
        );
      }

      emit(HabitsLoaded(habitsWithCompletion));
    } catch (e) {
      emit(HabitsError(e.toString()));
    }
  }

  Future<void> _onAddHabit(
      AddHabit event,
      Emitter<HabitsState> emit,
      ) async {
    try {
      await _repository.addHabit(event.habit);

      add(const LoadHabits());
    } catch (e) {
      emit(HabitsError(e.toString()));
    }
  }

  Future<void> _onUpdateHabit(
      UpdateHabit event,
      Emitter<HabitsState> emit,
      ) async {
    try {
      await _repository.updateHabit(event.habit);

      add(const LoadHabits());
    } catch (e) {
      emit(HabitsError(e.toString()));
    }
  }

  Future<void> _onDeleteHabit(
      DeleteHabit event,
      Emitter<HabitsState> emit,
      ) async {
    try {
      await _repository.deleteHabit(event.habitId);

      add(const LoadHabits());
    } catch (e) {
      emit(HabitsError(e.toString()));
    }
  }

  Future<void> _onArchiveHabit(
      ArchiveHabit event,
      Emitter<HabitsState> emit,
      ) async {
    try {
      await _repository.archiveHabit(event.habitId);

      add(const LoadHabits());
    } catch (e) {
      emit(HabitsError(e.toString()));
    }
  }

  Future<void> _onToggleHabitCompletion(
      ToggleHabitCompletion event,
      Emitter<HabitsState> emit,
      ) async {
    try {
      await _completionRepository.toggleCompletion(
        habitId: event.habit.id,
        date: DateTime.now(),
      );

      add(const LoadHabits());
    } catch (e) {
      emit(HabitsError(e.toString()));
    }
  }

}

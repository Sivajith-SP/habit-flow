import 'package:equatable/equatable.dart';

import '../../models/habit/habit_model.dart';

abstract class HabitsEvent extends Equatable {
  const HabitsEvent();

  @override
  List<Object?> get props => [];
}

class LoadHabits extends HabitsEvent {
  const LoadHabits();
}

class AddHabit extends HabitsEvent {
  final HabitModel habit;

  const AddHabit(this.habit);

  @override
  List<Object?> get props => [habit];
}

class UpdateHabit extends HabitsEvent {
  final HabitModel habit;

  const UpdateHabit(this.habit);

  @override
  List<Object?> get props => [habit];
}

class DeleteHabit extends HabitsEvent {
  final String habitId;

  const DeleteHabit(this.habitId);

  @override
  List<Object?> get props => [habitId];
}

class ArchiveHabit extends HabitsEvent {
  final String habitId;

  const ArchiveHabit(this.habitId);

  @override
  List<Object?> get props => [habitId];
}

class RestoreHabit extends HabitsEvent {
  final String habitId;

  const RestoreHabit(this.habitId);

  @override
  List<Object?> get props => [habitId];
}

class ToggleHabitCompletion extends HabitsEvent {
  final HabitModel habit;

  const ToggleHabitCompletion(this.habit);

  @override
  List<Object?> get props => [habit];
}

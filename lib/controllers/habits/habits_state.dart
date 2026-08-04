import 'package:equatable/equatable.dart';
import 'package:habitflow/models/habit/habit_with_completion.dart';

import '../../models/habit/habit_model.dart';

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

  const HabitsLoaded(this.habits);

  @override
  List<Object?> get props => [habits];
}

class HabitsError extends HabitsState {
  final String message;

  const HabitsError(this.message);

  @override
  List<Object?> get props => [message];
}

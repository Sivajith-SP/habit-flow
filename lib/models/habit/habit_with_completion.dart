import 'package:equatable/equatable.dart';

import 'habit_model.dart';

class HabitWithCompletion extends Equatable {
  final HabitModel habit;
  final bool isCompletedToday;

  const HabitWithCompletion({
    required this.habit,
    required this.isCompletedToday,
  });

  @override
  List<Object?> get props => [
    habit,
    isCompletedToday,
  ];
}
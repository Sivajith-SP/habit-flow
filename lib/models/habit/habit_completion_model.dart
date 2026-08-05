import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'habit_completion_model.g.dart';

@HiveType(typeId: 2)
class HabitCompletionModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String habitId;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final bool completed;

  @HiveField(4)
  final DateTime createdAt;

  const HabitCompletionModel({
    required this.id,
    required this.habitId,
    required this.date,
    required this.completed,
    required this.createdAt,
  });

  HabitCompletionModel copyWith({
    String? id,
    String? habitId,
    DateTime? date,
    bool? completed,
    DateTime? createdAt,
  }) {
    return HabitCompletionModel(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      date: date ?? this.date,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, habitId, date, completed, createdAt];
}

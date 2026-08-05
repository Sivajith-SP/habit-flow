import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../core/services/hive_service.dart';
import '../../models/habit/habit_completion_model.dart';
import 'completion_repository.dart';

class CompletionRepositoryImpl implements CompletionRepository {
  CompletionRepositoryImpl();

  final _uuid = const Uuid();

  Box<HabitCompletionModel> get _box =>
      Hive.box<HabitCompletionModel>(HiveService.completionsBox);

  @override
  Future<List<HabitCompletionModel>> getCompletions(String habitId) async {
    return _box.values
        .where((completion) => completion.habitId == habitId)
        .toList();
  }

  @override
  Future<bool> isCompleted({
    required String habitId,
    required DateTime date,
  }) async {
    try {
      final completion = _box.values.firstWhere(
        (completion) =>
            completion.habitId == habitId &&
            completion.date.year == date.year &&
            completion.date.month == date.month &&
            completion.date.day == date.day,
      );

      return completion.completed;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> toggleCompletion({
    required String habitId,
    required DateTime date,
  }) async {
    try {
      final completion = _box.values.firstWhere(
        (completion) =>
            completion.habitId == habitId &&
            completion.date.year == date.year &&
            completion.date.month == date.month &&
            completion.date.day == date.day,
      );

      final updated = completion.copyWith(completed: !completion.completed);

      await _box.put(updated.id, updated);
    } catch (_) {
      final completion = HabitCompletionModel(
        id: _uuid.v4(),
        habitId: habitId,
        date: date,
        completed: true,
        createdAt: DateTime.now(),
      );

      await _box.put(completion.id, completion);
    }
  }

  @override
  Future<List<bool>> getCurrentWeekProgress() async {
    final today = DateTime.now();

    // Monday of current week
    final monday = today.subtract(Duration(days: today.weekday - 1));

    final result = <bool>[];

    for (int i = 0; i < 7; i++) {
      final date = monday.add(Duration(days: i));

      final completed = _box.values.any(
        (completion) =>
            completion.completed &&
            completion.date.year == date.year &&
            completion.date.month == date.month &&
            completion.date.day == date.day,
      );

      result.add(completed);
    }

    return result;
  }

  @override
  Future<int> getCurrentStreak() async {
    int streak = 0;

    DateTime day = DateTime.now();

    while (true) {
      final completed = _box.values.any(
        (completion) =>
            completion.completed &&
            completion.date.year == day.year &&
            completion.date.month == day.month &&
            completion.date.day == day.day,
      );

      if (!completed) break;

      streak++;

      day = day.subtract(const Duration(days: 1));
    }

    return streak;
  }
}

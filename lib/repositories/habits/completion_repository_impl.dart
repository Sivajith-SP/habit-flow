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
}

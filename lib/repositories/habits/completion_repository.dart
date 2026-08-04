import '../../models/habit/habit_completion_model.dart';

abstract class CompletionRepository {
  Future<void> toggleCompletion({
    required String habitId,
    required DateTime date,
  });

  Future<bool> isCompleted({required String habitId, required DateTime date});

  Future<List<HabitCompletionModel>> getCompletions(String habitId);
}

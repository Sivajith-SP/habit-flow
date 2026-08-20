import '../../models/habit/habit_model.dart';

abstract class HabitRepository {
  Future<List<HabitModel>> getHabits();

  Future<void> addHabit(HabitModel habit);

  Future<void> updateHabit(HabitModel habit);

  Future<void> deleteHabit(String habitId);

  Future<void> archiveHabit(String habitId);

  Future<void> restoreHabit(String habitId);

  Future<HabitModel?> getHabitById(String habitId);

  Future<int> getMonthlyScheduledCount();
}

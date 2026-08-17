import 'package:hive/hive.dart';

import '../../core/services/hive_service.dart';
import '../../models/habit/habit_model.dart';
import 'habit_repository.dart';

class HabitRepositoryImpl implements HabitRepository {
  HabitRepositoryImpl();

  Box<HabitModel> get _box => Hive.box<HabitModel>(HiveService.habitsBox);

  @override
  Future<void> addHabit(HabitModel habit) async {
    await _box.put(habit.id, habit);
  }

  @override
  Future<void> archiveHabit(String habitId) async {
    final habit = _box.get(habitId);

    if (habit == null) return;

    final archivedHabit = habit.copyWith(
      isArchived: true,
      updatedAt: DateTime.now(),
    );

    await _box.put(habitId, archivedHabit);
  }

  @override
  Future<void> restoreHabit(String habitId) async {
    final habit = _box.get(habitId);

    if (habit == null) return;

    final restoredHabit = habit.copyWith(
      isArchived: false,
      updatedAt: DateTime.now(),
    );

    await _box.put(habitId, restoredHabit);
  }



  @override
  Future<void> deleteHabit(String habitId) async {
    await _box.delete(habitId);
  }

  @override
  Future<HabitModel?> getHabitById(String habitId) async {
    return _box.get(habitId);
  }

  @override
  Future<List<HabitModel>> getHabits() async {
    return _box.values.toList();
  }

  @override
  Future<void> updateHabit(HabitModel habit) async {
    await _box.put(habit.id, habit);
  }
}

import 'package:hive/hive.dart';

import '../../core/services/hive_service.dart';
import '../../models/habit/habit_frequency.dart';
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

  @override
  Future<int> getMonthlyScheduledCount() async {
    final now = DateTime.now();

    final firstDay = DateTime(now.year, now.month, 1);
    final lastDay = DateTime(now.year, now.month + 1, 0);

    final activeHabits = _box.values
        .where((habit) => !habit.isArchived)
        .toList();

    int total = 0;

    for (final habit in activeHabits) {
      for (
        DateTime date = firstDay;
        !date.isAfter(lastDay);
        date = date.add(const Duration(days: 1))
      ) {
        switch (habit.frequency) {
          case HabitFrequency.daily:
            total++;
            break;

          case HabitFrequency.weekly:
            // Weekly habit is scheduled on its first target day.
            if (habit.targetDays.contains(date.weekday - 1)) {
              total++;
            }
            break;

          case HabitFrequency.custom:
            if (habit.targetDays.contains(date.weekday - 1)) {
              total++;
            }
            break;
        }
      }
    }

    return total;
  }
}

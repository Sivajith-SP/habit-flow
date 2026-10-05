import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../core/services/hive_service.dart';
import '../../models/habit/habit_completion_model.dart';
import '../../models/habit/habit_model.dart';
import 'completion_repository.dart';
import 'habit_repository.dart';

class CompletionRepositoryImpl implements CompletionRepository {
  final HabitRepository? _habitRepository;

  CompletionRepositoryImpl([this._habitRepository]);

  final _uuid = const Uuid();

  Box<HabitCompletionModel> get _box =>
      Hive.box<HabitCompletionModel>(HiveService.completionsBox);

  Future<List<HabitModel>> _getHabits() async {
    if (_habitRepository != null) {
      return await _habitRepository.getHabits();
    }
    if (Hive.isBoxOpen(HiveService.habitsBox)) {
      return Hive.box<HabitModel>(HiveService.habitsBox).values.toList();
    }
    return [];
  }

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
    final habits = await _getHabits();
    final activeHabits = habits.where((h) => !h.isArchived).toList();

    final today = DateTime.now();
    // Monday of current week
    final monday = today.subtract(Duration(days: today.weekday - 1));

    final result = <bool>[];

    for (int i = 0; i < 7; i++) {
      final date = monday.add(Duration(days: i));
      final scheduled =
          activeHabits.where((h) => h.isScheduledOn(date)).toList();
      final totalForDay =
          scheduled.isNotEmpty ? scheduled.length : activeHabits.length;

      if (totalForDay == 0) {
        result.add(false);
        continue;
      }

      int completedCount = 0;
      for (final habit in (scheduled.isNotEmpty ? scheduled : activeHabits)) {
        final done = await isCompleted(habitId: habit.id, date: date);
        if (done) completedCount++;
      }

      result.add(completedCount >= totalForDay);
    }

    return result;
  }

  @override
  Future<List<int>> getCurrentWeekDailyCompletions() async {
    final habits = await _getHabits();
    final activeHabits = habits.where((h) => !h.isArchived).toList();

    final today = DateTime.now();
    final monday = today.subtract(Duration(days: today.weekday - 1));

    final result = <int>[];

    for (int i = 0; i < 7; i++) {
      final date = monday.add(Duration(days: i));
      int completedCount = 0;
      for (final habit in activeHabits) {
        final done = await isCompleted(habitId: habit.id, date: date);
        if (done) completedCount++;
      }
      result.add(completedCount);
    }

    return result;
  }

  @override
  Future<List<int>> getCurrentWeekDailyTotals() async {
    final habits = await _getHabits();
    final activeHabits = habits.where((h) => !h.isArchived).toList();

    final today = DateTime.now();
    final monday = today.subtract(Duration(days: today.weekday - 1));

    final result = <int>[];

    for (int i = 0; i < 7; i++) {
      final date = monday.add(Duration(days: i));
      final scheduled =
          activeHabits.where((h) => h.isScheduledOn(date)).toList();
      result.add(scheduled.isNotEmpty ? scheduled.length : activeHabits.length);
    }

    return result;
  }

  @override
  Future<int> getCurrentStreak() async {
    final allHabits = await _getHabits();
    final activeHabits = allHabits.where((h) => !h.isArchived).toList();

    if (activeHabits.isEmpty) {
      return 0;
    }

    bool isHabitCompleted(String habitId, DateTime date) {
      return _box.values.any(
        (completion) =>
            completion.habitId == habitId &&
            completion.completed &&
            completion.date.year == date.year &&
            completion.date.month == date.month &&
            completion.date.day == date.day,
      );
    }

    final earliestDate = activeHabits
        .map((h) => DateTime(h.createdAt.year, h.createdAt.month, h.createdAt.day))
        .reduce((a, b) => a.isBefore(b) ? a : b);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    int streak = 0;

    // Check today:
    final scheduledToday =
        activeHabits.where((h) => h.isScheduledOn(today)).toList();
    if (scheduledToday.isNotEmpty) {
      final todayCompleted =
          scheduledToday.any((h) => isHabitCompleted(h.id, today));
      if (todayCompleted) {
        streak++;
      }
    }

    // Traverse previous days backwards from yesterday:
    DateTime checkDay = today.subtract(const Duration(days: 1));

    while (!checkDay.isBefore(earliestDate)) {
      final scheduledOnDay = activeHabits.where((h) {
        final createdDay =
            DateTime(h.createdAt.year, h.createdAt.month, h.createdAt.day);
        return !checkDay.isBefore(createdDay) && h.isScheduledOn(checkDay);
      }).toList();

      if (scheduledOnDay.isEmpty) {
        // Unscheduled day: unscheduled days must not break the streak.
        checkDay = checkDay.subtract(const Duration(days: 1));
        continue;
      }

      final completed =
          scheduledOnDay.any((h) => isHabitCompleted(h.id, checkDay));

      if (completed) {
        streak++;
        checkDay = checkDay.subtract(const Duration(days: 1));
      } else {
        // Scheduled day was missed; streak breaks.
        break;
      }
    }

    return streak;
  }

  @override
  Future<int> getMonthlyCompleted() async {
    final now = DateTime.now();

    return _box.values.where((completion) {
      return completion.completed &&
          completion.date.year == now.year &&
          completion.date.month == now.month;
    }).length;
  }
}

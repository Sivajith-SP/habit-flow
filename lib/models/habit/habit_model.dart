import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import 'habit_frequency.dart';

part 'habit_model.g.dart';

@HiveType(typeId: 0)
class HabitModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int iconCodePoint;

  @HiveField(4)
  final int colorValue;

  @HiveField(5)
  final HabitFrequency frequency;

  @HiveField(6)
  final List<int> targetDays;

  @HiveField(7)
  final int? reminderMinutes;

  @HiveField(8)
  final bool isArchived;

  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
  final DateTime updatedAt;

  const HabitModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconCodePoint,
    required this.colorValue,
    required this.frequency,
    required this.targetDays,
    this.reminderMinutes,
    this.isArchived = false,
    required this.createdAt,
    required this.updatedAt,
  });

  HabitModel copyWith({
    String? id,
    String? title,
    String? description,
    int? iconCodePoint,
    int? colorValue,
    HabitFrequency? frequency,
    List<int>? targetDays,
    int? reminderMinutes,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HabitModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      colorValue: colorValue ?? this.colorValue,
      frequency: frequency ?? this.frequency,
      targetDays: targetDays ?? this.targetDays,
      reminderMinutes: reminderMinutes ?? this.reminderMinutes,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    iconCodePoint,
    colorValue,
    frequency,
    targetDays,
    reminderMinutes,
    isArchived,
    createdAt,
    updatedAt,
  ];

  /// Checks if this habit is scheduled to be performed on [date].
  bool isScheduledOn(DateTime date) {
    if (isArchived) return false;
    switch (frequency) {
      case HabitFrequency.daily:
        return true;
      case HabitFrequency.weekly:
      case HabitFrequency.custom:
        if (targetDays.isNotEmpty) {
          return targetDays.contains(date.weekday) ||
              (targetDays.contains(0) && targetDays.contains(date.weekday - 1));
        }
        return createdAt.weekday == date.weekday;
    }
  }

  /// Checks if this habit is scheduled for the given [weekday] (1 = Mon .. 7 = Sun).
  bool isScheduledForWeekday(int weekday) {
    if (isArchived) return false;
    switch (frequency) {
      case HabitFrequency.daily:
        return true;
      case HabitFrequency.weekly:
      case HabitFrequency.custom:
        if (targetDays.isNotEmpty) {
          return targetDays.contains(weekday) ||
              (targetDays.contains(0) && targetDays.contains(weekday - 1));
        }
        return createdAt.weekday == weekday;
    }
  }

  /// Returns the user-facing schedule display string.
  /// For Custom frequency with all 7 days selected, displays "Every day"
  /// while the underlying frequency remains Custom.
  String get scheduleCaption {
    switch (frequency) {
      case HabitFrequency.daily:
        return 'Every day';
      case HabitFrequency.weekly:
        return 'Once a week';
      case HabitFrequency.custom:
        return targetDays.length == 7
            ? 'Every day'
            : '${targetDays.length} selected';
    }
  }
}

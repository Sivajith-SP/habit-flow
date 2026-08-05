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
}

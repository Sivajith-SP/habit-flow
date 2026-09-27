import 'package:flutter/material.dart';

import '../../../models/habit/habit_model.dart';
import 'create_habit/create_habit_sheet.dart';

export 'create_habit/bento_cell.dart';
export 'create_habit/create_habit_sheet.dart';
export 'create_habit/days_cell.dart';
export 'create_habit/icon_cell.dart';
export 'create_habit/name_cell.dart';
export 'create_habit/repeat_cell.dart';
export 'create_habit/save_habit_button.dart';

/// Legacy entry point that renders the redesigned [CreateHabitSheet].
class AddHabitBottomSheet extends StatelessWidget {
  final HabitModel? habit;

  const AddHabitBottomSheet({super.key, this.habit});

  /// Opens the Create Habit bottom sheet.
  static Future<T?> show<T>(BuildContext context, {HabitModel? habit}) {
    return CreateHabitSheet.show<T>(context, habit: habit);
  }

  @override
  Widget build(BuildContext context) {
    return CreateHabitSheet(habit: habit);
  }
}

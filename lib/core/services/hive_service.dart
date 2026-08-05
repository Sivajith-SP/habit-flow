import 'package:hive_flutter/hive_flutter.dart';

import '../../models/habit/habit_completion_model.dart';
import '../../models/habit/habit_frequency.dart';
import '../../models/habit/habit_model.dart';

class HiveService {
  HiveService._();

  static const String habitsBox = 'habits';
  static const String completionsBox = 'habit_completions';

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(HabitFrequencyAdapter());
    Hive.registerAdapter(HabitModelAdapter());
    Hive.registerAdapter(HabitCompletionModelAdapter());

    await Hive.openBox<HabitModel>(habitsBox);
    await Hive.openBox<HabitCompletionModel>(completionsBox);
  }
}

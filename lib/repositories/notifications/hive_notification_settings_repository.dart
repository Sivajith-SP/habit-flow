
import 'package:hive/hive.dart';

import '../../models/notification/notification_settings.dart';
import 'notification_settings_repository.dart';

class HiveNotificationSettingsRepository
    implements NotificationSettingsRepository {
  static const String _boxName = 'notification_settings';

  Future<Box> get _box async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box(_boxName);
    }

    return Hive.openBox(_boxName);
  }

  @override
  Future<NotificationSettings> getSettings() async {
    final box = await _box;

    return NotificationSettings(
      notificationsEnabled:
      box.get('notificationsEnabled', defaultValue: true) as bool,
      habitRemindersEnabled:
      box.get('habitRemindersEnabled', defaultValue: true) as bool,
      reminderHour:
      box.get('reminderHour', defaultValue: 20) as int,
      reminderMinute:
      box.get('reminderMinute', defaultValue: 0) as int,
    );
  }

  @override
  Future<void> saveSettings(
      NotificationSettings settings,
      ) async {
    final box = await _box;

    await box.put(
      'notificationsEnabled',
      settings.notificationsEnabled,
    );

    await box.put(
      'habitRemindersEnabled',
      settings.habitRemindersEnabled,
    );

    await box.put(
      'reminderHour',
      settings.reminderHour,
    );

    await box.put(
      'reminderMinute',
      settings.reminderMinute,
    );
  }
}
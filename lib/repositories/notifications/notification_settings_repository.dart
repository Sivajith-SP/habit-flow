import '../../models/notification/notification_settings.dart';

abstract class NotificationSettingsRepository {
  Future<NotificationSettings> getSettings();

  Future<void> saveSettings(NotificationSettings settings);
}
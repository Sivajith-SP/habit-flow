class NotificationSettings {
  final bool notificationsEnabled;
  final bool habitRemindersEnabled;
  final int reminderHour;
  final int reminderMinute;

  const NotificationSettings({
    required this.notificationsEnabled,
    required this.habitRemindersEnabled,
    required this.reminderHour,
    required this.reminderMinute,
  });

  NotificationSettings copyWith({
    bool? notificationsEnabled,
    bool? habitRemindersEnabled,
    int? reminderHour,
    int? reminderMinute,
  }) {
    return NotificationSettings(
      notificationsEnabled:
      notificationsEnabled ?? this.notificationsEnabled,
      habitRemindersEnabled:
      habitRemindersEnabled ?? this.habitRemindersEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
    );
  }
}
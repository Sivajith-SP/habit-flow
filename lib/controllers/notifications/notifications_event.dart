import 'package:equatable/equatable.dart';

sealed class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

final class LoadNotificationSettings extends NotificationsEvent {
  const LoadNotificationSettings();
}

final class NotificationsEnabledChanged extends NotificationsEvent {
  final bool enabled;

  const NotificationsEnabledChanged(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

final class HabitRemindersEnabledChanged extends NotificationsEvent {
  final bool enabled;

  const HabitRemindersEnabledChanged(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

final class ReminderTimeChanged extends NotificationsEvent {
  final int hour;
  final int minute;

  const ReminderTimeChanged({
    required this.hour,
    required this.minute,
  });

  @override
  List<Object?> get props => [hour, minute];
}
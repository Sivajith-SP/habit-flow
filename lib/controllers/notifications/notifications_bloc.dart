import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/services/notification_service.dart';
import '../../repositories/notifications/notification_settings_repository.dart';
import 'notifications_event.dart';
import 'notifications_state.dart';

class NotificationsBloc
    extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationSettingsRepository _repository;
  final NotificationService _notificationService;

  NotificationsBloc(
      this._repository,
      this._notificationService,
      ) : super(const NotificationsInitial()) {
    on<LoadNotificationSettings>(_onLoadSettings);
    on<NotificationsEnabledChanged>(
      _onNotificationsEnabledChanged,
    );
    on<HabitRemindersEnabledChanged>(
      _onHabitRemindersEnabledChanged,
    );
    on<ReminderTimeChanged>(
      _onReminderTimeChanged,
    );
  }

  Future<void> _onLoadSettings(
      LoadNotificationSettings event,
      Emitter<NotificationsState> emit,
      ) async {
    emit(const NotificationsLoading());

    try {
      final settings = await _repository.getSettings();

      emit(NotificationsLoaded(settings));
    } catch (e) {
      emit(
        NotificationsFailure(
          e.toString(),
        ),
      );
    }
  }

  Future<void> _onNotificationsEnabledChanged(
      NotificationsEnabledChanged event,
      Emitter<NotificationsState> emit,
      ) async {
    final currentState = state;

    if (currentState is! NotificationsLoaded) return;

    try {
      var settings = currentState.settings.copyWith(
        notificationsEnabled: event.enabled,
      );

      if (!event.enabled) {
        settings = settings.copyWith(
          habitRemindersEnabled: false,
        );

        await _notificationService.cancelDailyReminder();
      }

      await _repository.saveSettings(settings);

      emit(NotificationsLoaded(settings));
    } catch (e) {
      emit(
        NotificationsFailure(
          e.toString(),
        ),
      );
    }
  }

  Future<void> _onHabitRemindersEnabledChanged(
      HabitRemindersEnabledChanged event,
      Emitter<NotificationsState> emit,
      ) async {
    final currentState = state;

    if (currentState is! NotificationsLoaded) return;

    try {
      final settings = currentState.settings.copyWith(
        habitRemindersEnabled: event.enabled,
      );

      if (event.enabled && settings.notificationsEnabled) {
        await _notificationService.scheduleDailyReminder(
          hour: settings.reminderHour,
          minute: settings.reminderMinute,
        );
      } else {
        await _notificationService.cancelDailyReminder();
      }

      await _repository.saveSettings(settings);

      emit(NotificationsLoaded(settings));
    } catch (e) {
      emit(
        NotificationsFailure(
          e.toString(),
        ),
      );
    }
  }

  Future<void> _onReminderTimeChanged(
      ReminderTimeChanged event,
      Emitter<NotificationsState> emit,
      ) async {
    final currentState = state;

    if (currentState is! NotificationsLoaded) return;

    try {
      final settings = currentState.settings.copyWith(
        reminderHour: event.hour,
        reminderMinute: event.minute,
      );

      if (settings.notificationsEnabled &&
          settings.habitRemindersEnabled) {
        await _notificationService.cancelDailyReminder();

        await _notificationService.scheduleDailyReminder(
          hour: settings.reminderHour,
          minute: settings.reminderMinute,
        );
      }

      await _repository.saveSettings(settings);

      emit(NotificationsLoaded(settings));
    } catch (e) {
      emit(
        NotificationsFailure(
          e.toString(),
        ),
      );
    }
  }
}
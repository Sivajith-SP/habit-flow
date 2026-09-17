import 'package:equatable/equatable.dart';

import '../../models/notification/notification_settings.dart';

sealed class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

final class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

final class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

final class NotificationsLoaded extends NotificationsState {
  final NotificationSettings settings;

  const NotificationsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];
}

final class NotificationsFailure extends NotificationsState {
  final String message;

  const NotificationsFailure(this.message);

  @override
  List<Object?> get props => [message];
}
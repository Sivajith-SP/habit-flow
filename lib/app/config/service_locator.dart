import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:habitflow/controllers/auth/auth_bloc.dart';

import '../../controllers/habits/habits_bloc.dart';
import '../../controllers/notifications/notifications_bloc.dart';
import '../../controllers/statistics/statistics_bloc.dart';
import '../../core/services/notification_service.dart';
import '../../repositories/auth/auth_repository.dart';
import '../../repositories/auth/firebase_auth_repository.dart';
import '../../repositories/habits/completion_repository.dart';
import '../../repositories/habits/completion_repository_impl.dart';
import '../../repositories/habits/habit_repository.dart';
import '../../repositories/habits/habit_repository_impl.dart';
import '../../repositories/notifications/hive_notification_settings_repository.dart';
import '../../repositories/notifications/notification_settings_repository.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Firebase
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => FirebaseAuthRepository(getIt<FirebaseAuth>()),
  );

  getIt.registerLazySingleton<HabitRepository>(() => HabitRepositoryImpl());

  getIt.registerLazySingleton<CompletionRepository>(
    () => CompletionRepositoryImpl(),
  );

  getIt.registerLazySingleton<NotificationSettingsRepository>(
        () => HiveNotificationSettingsRepository(),
  );

  // Controllers / Blocs
  // Singleton so all screens (Dashboard, Profile, etc.) share the same
  // AuthBloc instance and react to state changes (e.g. UpdateUserNameRequested)
  // without needing an app restart.
  getIt.registerLazySingleton<AuthBloc>(() => AuthBloc(getIt<AuthRepository>()));

  getIt.registerFactory<HabitsBloc>(
    () => HabitsBloc(getIt<HabitRepository>(), getIt<CompletionRepository>()),
  );

  getIt.registerFactory<StatisticsBloc>(
    () =>
        StatisticsBloc(getIt<CompletionRepository>(), getIt<HabitRepository>()),
  );

  getIt.registerFactory<NotificationsBloc>(
        () => NotificationsBloc(
      getIt<NotificationSettingsRepository>(), NotificationService.instance,
    ),
  );
}

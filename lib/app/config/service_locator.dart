import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:habitflow/controllers/auth/auth_bloc.dart';

import '../../controllers/habits/habits_bloc.dart';
import '../../controllers/statistics/statistics_bloc.dart';
import '../../repositories/auth/auth_repository.dart';
import '../../repositories/auth/firebase_auth_repository.dart';
import '../../repositories/habits/completion_repository.dart';
import '../../repositories/habits/completion_repository_impl.dart';
import '../../repositories/habits/habit_repository.dart';
import '../../repositories/habits/habit_repository_impl.dart';

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

  // Controllers / Blocs
  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<AuthRepository>()));

  getIt.registerFactory<HabitsBloc>(
    () => HabitsBloc(getIt<HabitRepository>(), getIt<CompletionRepository>()),
  );

  getIt.registerFactory<StatisticsBloc>(
    () =>
        StatisticsBloc(getIt<CompletionRepository>(), getIt<HabitRepository>()),
  );
}

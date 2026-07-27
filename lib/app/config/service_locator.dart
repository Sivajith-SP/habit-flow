import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:habitflow/controllers/auth/auth_bloc.dart';

import '../../repositories/auth/auth_repository.dart';
import '../../repositories/auth/firebase_auth_repository.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Firebase
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => FirebaseAuthRepository(getIt<FirebaseAuth>()),
  );

  // Controllers / Blocs
  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<AuthRepository>()));
}

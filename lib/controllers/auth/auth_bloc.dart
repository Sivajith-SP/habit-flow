import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/auth_exception_handler.dart';
import '../../repositories/auth/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<UpdateUserNameRequested>(_onUpdateUserNameRequested);
    on<ChangePasswordRequested>(_onChangePasswordRequested);
    on<DeleteAccountRequested>(_onDeleteAccountRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await _authRepository.login(email: event.email, password: event.password);

      final userName =
          _authRepository.currentUserDisplayName?.trim().isNotEmpty == true
          ? _authRepository.currentUserDisplayName!
          : 'HabitFlow User';

      emit(AuthSuccess(userName: userName));
    } catch (e) {
      emit(AuthFailure(FirebaseAuthExceptionHandler.getMessage(e)));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await _authRepository.register(
        email: event.email,
        password: event.password,
      );

      final userName =
          _authRepository.currentUserDisplayName?.trim().isNotEmpty == true
          ? _authRepository.currentUserDisplayName!
          : 'HabitFlow User';

      emit(AuthSuccess(userName: userName));
    } catch (e) {
      emit(AuthFailure(FirebaseAuthExceptionHandler.getMessage(e)));
    }
  }

  Future<void> _onUpdateUserNameRequested(
    UpdateUserNameRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await _authRepository.updateUserName(event.name);

      emit(AuthSuccess(userName: event.name));
    } catch (e) {
      emit(AuthFailure(FirebaseAuthExceptionHandler.getMessage(e)));
    }
  }

  Future<void> _onChangePasswordRequested(
    ChangePasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await _authRepository.changePassword(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
      );

      final userName =
          _authRepository.currentUserDisplayName?.trim().isNotEmpty == true
          ? _authRepository.currentUserDisplayName!
          : 'HabitFlow User';

      emit(AuthSuccess(userName: userName));
    } catch (e) {
      emit(AuthFailure(FirebaseAuthExceptionHandler.getMessage(e)));
    }
  }

  Future<void> _onDeleteAccountRequested(
      DeleteAccountRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    try {
      await _authRepository.deleteAccount(
        password: event.password,
      );

      emit(AuthInitial());
    } catch (e) {
      emit(
        AuthFailure(
          FirebaseAuthExceptionHandler.getMessage(e),
        ),
      );
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await _authRepository.logout();

      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure(FirebaseAuthExceptionHandler.getMessage(e)));
    }
  }
}

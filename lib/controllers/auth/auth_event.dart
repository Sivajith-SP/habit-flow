import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Check whether the user is already authenticated
final class AuthStatusChecked extends AuthEvent {
  const AuthStatusChecked();
}

final class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

final class RegisterRequested extends AuthEvent {
  final String email;
  final String password;

  const RegisterRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

final class UpdateUserNameRequested extends AuthEvent {
  final String name;

  const UpdateUserNameRequested(this.name);

  @override
  List<Object?> get props => [name];
}

final class ChangePasswordRequested extends AuthEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordRequested({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [
    currentPassword,
    newPassword,
  ];
}

final class DeleteAccountRequested extends AuthEvent {
  final String password;

  const DeleteAccountRequested({
    required this.password,
  });

  @override
  List<Object?> get props => [password];
}

final class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
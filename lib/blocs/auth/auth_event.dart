part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested();
}

class AuthRegisterRequested extends AuthEvent {
  const AuthRegisterRequested();
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthEmailChanged extends AuthEvent {
  final String email;

  const AuthEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class AuthPasswordChanged extends AuthEvent {
  final String password;

  const AuthPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class AuthNameChanged extends AuthEvent {
  final String name;

  const AuthNameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

class AuthConfirmPasswordChanged extends AuthEvent {
  final String confirmPassword;

  const AuthConfirmPasswordChanged(this.confirmPassword);

  @override
  List<Object?> get props => [confirmPassword];
}

class AuthForgotPasswordRequested extends AuthEvent {
  const AuthForgotPasswordRequested();
}

class AuthTogglePasswordVisibility extends AuthEvent {
  const AuthTogglePasswordVisibility();
}

class AuthToggleConfirmPasswordVisibility extends AuthEvent {
  const AuthToggleConfirmPasswordVisibility();
}

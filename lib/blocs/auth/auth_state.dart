part of 'auth_bloc.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  passwordResetSent,
  error,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final Email email;
  final Password password;
  final Name name;
  final ConfirmedPassword confirmedPassword;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final User? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.name = const Name.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.user,
    this.errorMessage,
  });

  bool get isValidLogin {
    return email.isValid && password.isValid;
  }

  bool get isValidRegister {
    return email.isValid &&
        password.isValid &&
        name.isValid &&
        confirmedPassword.isValid;
  }

  AuthState copyWith({
    AuthStatus? status,
    Email? email,
    Password? password,
    Name? name,
    ConfirmedPassword? confirmedPassword,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    User? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible: isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        email,
        password,
        name,
        confirmedPassword,
        isPasswordVisible,
        isConfirmPasswordVisible,
        user,
        errorMessage,
      ];
}

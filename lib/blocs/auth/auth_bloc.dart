import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/user_model.dart';
import '../../models/form_inputs.dart';
import '../../services/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc({required AuthService authService})
    : _authService = authService,
      super(const AuthState()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthEmailChanged>(_onAuthEmailChanged);
    on<AuthPasswordChanged>(_onAuthPasswordChanged);
    on<AuthNameChanged>(_onAuthNameChanged);
    on<AuthConfirmPasswordChanged>(_onAuthConfirmPasswordChanged);
    on<AuthForgotPasswordRequested>(_onAuthForgotPasswordRequested);
    on<AuthTogglePasswordVisibility>(_onAuthTogglePasswordVisibility);
    on<AuthToggleConfirmPasswordVisibility>(
      _onAuthToggleConfirmPasswordVisibility,
    );
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final isAuthenticated = await _authService.isAuthenticated();
      if (isAuthenticated) {
        final user = await _authService.getCurrentUser();
        emit(state.copyWith(status: AuthStatus.authenticated, user: user));
      } else {
        emit(state.copyWith(status: AuthStatus.unauthenticated));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (!state.isValidLogin) return;

    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final user = await _authService.login(
        state.email.value,
        state.password.value,
      );
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          errorMessage: null,
        ),
      );
    } on AuthException catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: 'An unexpected error occurred',
        ),
      );
    }
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (!state.isValidRegister) return;

    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final user = await _authService.register(
        state.email.value,
        state.password.value,
        state.name.value,
      );
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          errorMessage: null,
        ),
      );
    } on AuthException catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: 'An unexpected error occurred',
        ),
      );
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      await _authService.logout();
      emit(const AuthState(status: AuthStatus.unauthenticated));
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.error, errorMessage: e.toString()),
      );
    }
  }

  void _onAuthEmailChanged(AuthEmailChanged event, Emitter<AuthState> emit) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        status: AuthStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onAuthPasswordChanged(
    AuthPasswordChanged event,
    Emitter<AuthState> emit,
  ) {
    final password = Password.dirty(event.password);
    final confirmPassword = ConfirmedPassword.dirty(
      password: password,
      value: state.confirmedPassword.value,
    );
    emit(
      state.copyWith(
        password: password,
        confirmedPassword: confirmPassword,
        status: AuthStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onAuthNameChanged(AuthNameChanged event, Emitter<AuthState> emit) {
    final name = Name.dirty(event.name);
    emit(
      state.copyWith(
        name: name,
        status: AuthStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onAuthConfirmPasswordChanged(
    AuthConfirmPasswordChanged event,
    Emitter<AuthState> emit,
  ) {
    final confirmPassword = ConfirmedPassword.dirty(
      password: state.password,
      value: event.confirmPassword,
    );
    emit(
      state.copyWith(
        confirmedPassword: confirmPassword,
        status: AuthStatus.initial,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onAuthForgotPasswordRequested(
    AuthForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state.email.value.isEmpty) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Please enter your email',
        ),
      );
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading));

    try {
      await _authService.forgotPassword(state.email.value);
      emit(
        state.copyWith(
          status: AuthStatus.passwordResetSent,
          errorMessage: null,
        ),
      );
    } on AuthException catch (e) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: e.message));
    }
  }

  void _onAuthTogglePasswordVisibility(
    AuthTogglePasswordVisibility event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void _onAuthToggleConfirmPasswordVisibility(
    AuthToggleConfirmPasswordVisibility event,
    Emitter<AuthState> emit,
  ) {
    emit(
      state.copyWith(isConfirmPasswordVisible: !state.isConfirmPasswordVisible),
    );
  }
}

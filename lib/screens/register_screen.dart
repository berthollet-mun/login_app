import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../blocs/auth/auth_bloc.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/social_login_buttons.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            context.go('/');
          } else if (state.status == AuthStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'An error occurred'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // Back Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(FontAwesomeIcons.arrowLeft),
                    onPressed: () => context.go('/login'),
                  ),
                ),
                const SizedBox(height: 10),
                // Logo
                Center(
                  child: Image.asset(
                    'assets/images/logo1.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),
                // Title
                Text(
                  'Create Account',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign up to start shopping',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Demo credentials hint
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Text(
                    'Demo: Create any account with password (6+ characters)',
                    style: TextStyle(color: Colors.green[800], fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                // Register Form
                const _RegisterForm(),
                const SizedBox(height: 24),
                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey[300])),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey[300])),
                  ],
                ),
                const SizedBox(height: 24),
                // Social Login
                const SocialLoginButtons(),
                const SizedBox(height: 24),
                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: const Text('Sign In'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Column(
          children: [
            CustomTextField(
              label: 'Full Name',
              hint: 'Enter your full name',
              prefixIcon: FontAwesomeIcons.user,
              onChanged: (value) {
                context.read<AuthBloc>().add(AuthNameChanged(value));
              },
              errorText: state.name.displayError != null
                  ? 'Please enter a valid name'
                  : null,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Email',
              hint: 'Enter your email',
              prefixIcon: FontAwesomeIcons.envelope,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                context.read<AuthBloc>().add(AuthEmailChanged(value));
              },
              errorText: state.email.displayError != null
                  ? 'Please enter a valid email'
                  : null,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Password',
              hint: 'Create a password',
              prefixIcon: FontAwesomeIcons.lock,
              obscureText: !state.isPasswordVisible,
              suffixIcon: IconButton(
                icon: Icon(
                  state.isPasswordVisible
                      ? FontAwesomeIcons.eye
                      : FontAwesomeIcons.eyeSlash,
                  size: 20,
                ),
                onPressed: () {
                  context.read<AuthBloc>().add(
                    const AuthTogglePasswordVisibility(),
                  );
                },
              ),
              onChanged: (value) {
                context.read<AuthBloc>().add(AuthPasswordChanged(value));
              },
              errorText: state.password.displayError != null
                  ? 'Password must be at least 8 characters with letters and numbers'
                  : null,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Confirm Password',
              hint: 'Confirm your password',
              prefixIcon: FontAwesomeIcons.lock,
              obscureText: !state.isConfirmPasswordVisible,
              suffixIcon: IconButton(
                icon: Icon(
                  state.isConfirmPasswordVisible
                      ? FontAwesomeIcons.eye
                      : FontAwesomeIcons.eyeSlash,
                  size: 20,
                ),
                onPressed: () {
                  context.read<AuthBloc>().add(
                    const AuthToggleConfirmPasswordVisibility(),
                  );
                },
              ),
              onChanged: (value) {
                context.read<AuthBloc>().add(AuthConfirmPasswordChanged(value));
              },
              errorText: state.confirmedPassword.displayError != null
                  ? 'Passwords do not match'
                  : null,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Create Account',
              isLoading: state.status == AuthStatus.loading,
              onPressed: state.isValidRegister
                  ? () {
                      context.read<AuthBloc>().add(
                        const AuthRegisterRequested(),
                      );
                    }
                  : null,
            ),
          ],
        );
      },
    );
  }
}

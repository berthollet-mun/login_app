import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../blocs/auth/auth_bloc.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/social_login_buttons.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                const SizedBox(height: 40),
                // Logo
                Center(
                  child: Image.asset(
                    'assets/images/logo1.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Welcome Back!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue shopping',
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
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Text(
                    'Demo: Use any email with password "password123"',
                    style: TextStyle(color: Colors.blue[800], fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),
                // Login Form
                const _LoginForm(),
                const SizedBox(height: 24),
                // Forgot Password
                TextButton(
                  onPressed: () => context.go('/forgot-password'),
                  child: const Text('Forgot Password?'),
                ),
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
                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    TextButton(
                      onPressed: () => context.go('/register'),
                      child: const Text('Sign Up'),
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

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Column(
          children: [
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
              hint: 'Enter your password',
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
                  ? 'Password must be at least 8 characters'
                  : null,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Sign In',
              isLoading: state.status == AuthStatus.loading,
              onPressed: state.isValidLogin
                  ? () {
                      context.read<AuthBloc>().add(const AuthLoginRequested());
                    }
                  : null,
            ),
          ],
        );
      },
    );
  }
}

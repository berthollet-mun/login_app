import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../blocs/auth/auth_bloc.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.passwordResetSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Password reset link sent to your email!'),
                backgroundColor: Colors.green,
              ),
            );
            Future.delayed(const Duration(seconds: 2), () {
              context.go('/login');
            });
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
                const SizedBox(height: 40),
                // Icon
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      FontAwesomeIcons.lockOpen,
                      size: 40,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Title
                Text(
                  'Forgot Password?',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Enter your email address and we\'ll send you a link to reset your password.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // Form
                const _ForgotPasswordForm(),
                const SizedBox(height: 24),
                // Back to Login
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Back to Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ForgotPasswordForm extends StatelessWidget {
  const _ForgotPasswordForm();

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
            const SizedBox(height: 24),
            CustomButton(
              text: 'Send Reset Link',
              isLoading: state.status == AuthStatus.loading,
              onPressed: state.email.isValid
                  ? () {
                      context.read<AuthBloc>().add(const AuthForgotPasswordRequested());
                    }
                  : null,
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/auth/auth_bloc.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/social_login_buttons.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            context.go('/');
          } else if (state.status == AuthStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'An error occurred'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg1.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: isTablet
              ? Row(
                  children: [
                    // Background takes left side
                    Expanded(flex: 1, child: SizedBox.expand()),
                    // Form takes right side
                    Expanded(
                      flex: 1,
                      child: SafeArea(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 20),
                              _buildFormContent(),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : // Mobile: Form card floats on top of background
              SafeArea(
                  child: Column(
                    children: [
                      // Top section with back button - sparse
                      SizedBox(
                        height: 60,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios, 
                              size: 20, 
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      // Spacer to push card down
                      Expanded(child: Container()),
                      // White card with form
                      SingleChildScrollView(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: _buildFormContent(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/logo1.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.shopping_bag_outlined,
                        size: 40,
                        color: const Color(0xFF6C63FF),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Title
            Text(
              'Welcome back',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A1A1A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Sign in to access your account and continue shopping',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Demo hint
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Colors.blue[700],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Demo: any email + password "password123"',
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Login Form
            CustomTextField(
              label: 'Email',
              hint: 'Enter your email',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                context.read<AuthBloc>().add(AuthEmailChanged(value));
              },
              errorText:
                  state.email.displayError != null
                      ? 'Please enter a valid email'
                      : null,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Password',
              hint: 'Enter your password',
              prefixIcon: Icons.lock_outline,
              obscureText: !state.isPasswordVisible,
              suffixIcon: IconButton(
                icon: Icon(
                  state.isPasswordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: Colors.grey[600],
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
              errorText:
                  state.password.displayError != null
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
            const SizedBox(height: 16),
            // Forgot Password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.go('/forgot-password'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF6C63FF),
                  padding: EdgeInsets.zero,
                ),
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
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
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
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
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                TextButton(
                  onPressed: () => context.go('/register'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF6C63FF),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../blocs/auth/auth_bloc.dart';
import '../widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.arrowLeft),
          onPressed: () => context.go('/'),
        ),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final user = state.user;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Text(
                          user?.name.isNotEmpty == true
                              ? user!.name[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user?.name ?? 'Guest User',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? 'No email provided',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Menu Items
                _buildMenuItem(
                  context,
                  icon: FontAwesomeIcons.user,
                  title: 'Edit Profile',
                  subtitle: 'Update your personal information',
                  onTap: () {
                    // TODO: Navigate to edit profile
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: FontAwesomeIcons.bagShopping,
                  title: 'My Orders',
                  subtitle: 'View your order history',
                  onTap: () {
                    // TODO: Navigate to orders
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: FontAwesomeIcons.heart,
                  title: 'Wishlist',
                  subtitle: 'Your saved products',
                  onTap: () {
                    // TODO: Navigate to wishlist
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: FontAwesomeIcons.locationDot,
                  title: 'Addresses',
                  subtitle: 'Manage delivery addresses',
                  onTap: () {
                    // TODO: Navigate to addresses
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: FontAwesomeIcons.creditCard,
                  title: 'Payment Methods',
                  subtitle: 'Manage your payment options',
                  onTap: () {
                    // TODO: Navigate to payment methods
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: FontAwesomeIcons.gear,
                  title: 'Settings',
                  subtitle: 'App preferences and settings',
                  onTap: () {
                    // TODO: Navigate to settings
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: FontAwesomeIcons.circleQuestion,
                  title: 'Help & Support',
                  subtitle: 'Get help with your orders',
                  onTap: () {
                    // TODO: Navigate to support
                  },
                ),
                const SizedBox(height: 24),
                // Logout Button
                CustomButton(
                  text: 'Logout',
                  isOutlined: true,
                  backgroundColor: Colors.red,
                  onPressed: () {
                    _showLogoutDialog(context);
                  },
                ),
                const SizedBox(height: 32),
                // App Version
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        trailing: Icon(
          FontAwesomeIcons.chevronRight,
          size: 16,
          color: Colors.grey[400],
        ),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AuthBloc>().add(const AuthLogoutRequested());
              context.go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

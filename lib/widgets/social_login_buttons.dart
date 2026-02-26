import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'custom_button.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          text: 'Continue with Google',
          isOutlined: true,
          icon: const Icon(
            FontAwesomeIcons.google,
            size: 20,
          ),
          onPressed: () {
            // TODO: Implement Google Sign In
            _showComingSoon(context);
          },
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: 'Continue with Apple',
          isOutlined: true,
          icon: const Icon(
            FontAwesomeIcons.apple,
            size: 20,
          ),
          onPressed: () {
            // TODO: Implement Apple Sign In
            _showComingSoon(context);
          },
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: 'Continue with Facebook',
          isOutlined: true,
          icon: const Icon(
            FontAwesomeIcons.facebook,
            size: 20,
          ),
          onPressed: () {
            // TODO: Implement Facebook Sign In
            _showComingSoon(context);
          },
        ),
      ],
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:login_page/main.dart';
import 'package:login_page/services/auth_service.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Setup SharedPreferences for testing
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final authService = AuthService(prefs: prefs);

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(authService: authService));
    await tester.pumpAndSettle();

    // Verify that the login screen is shown (initial unauthenticated state)
    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.text('Sign in to continue shopping'), findsOneWidget);
  });
}

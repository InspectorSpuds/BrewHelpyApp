import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:brewhelpy/login.dart';

void main() {
  testWidgets('Login screen should build its UI components correctly', (
      WidgetTester tester) async {
    //Arrange
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));

    //Act
    final usernameField = find.widgetWithText(TextField, 'Username');
    final passwordField = find.widgetWithText(TextField, 'Password');
    final loginButton = find.widgetWithText(ElevatedButton, 'Log In');

    //Assert
    expect(usernameField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(loginButton, findsOneWidget);
  });

  testWidgets('Login function should be called with valid inputs', (
      WidgetTester tester) async {
    //Arrange
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    await tester.enterText(
        find.widgetWithText(TextField, 'Username'), 'testUser');
    await tester.enterText(
        find.widgetWithText(TextField, 'Password'), 'testPass');

    //Act
    await tester.tap(find.widgetWithText(ElevatedButton, 'Log In'));
    await tester.pump();
  });
  testWidgets('Logout function should be called', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));

    // Log in first
    await tester.enterText(
        find.widgetWithText(TextField, 'Username'), 'testUser');
    await tester.enterText(
        find.widgetWithText(TextField, 'Password'), 'testPass');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Log In'));
    await tester.pump();

    // Act
    await tester.tap(find.widgetWithText(ElevatedButton, 'Log Out'));
    await tester.pump();

    // Assert
    // Check for the logout state or message (requires ScaffoldMessenger to be correctly used in the LoginScreen)
    expect(find.text('Successfully logged out'), findsOneWidget);
  });
}

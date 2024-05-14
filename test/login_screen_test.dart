//Author: Eugene Keehan
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:brewhelpy/login.dart';

void main() {
  testWidgets('Login screen should build its UI components correctly', (
      WidgetTester tester) async {
    //Arrange
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

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
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
    await tester.enterText(
        find.widgetWithText(TextField, 'Username'), 'testUser');
    await tester.enterText(
        find.widgetWithText(TextField, 'Password'), 'testPass');

    //Act
    await tester.tap(find.widgetWithText(ElevatedButton, 'Log In'));
    await tester.pump();
  });
}
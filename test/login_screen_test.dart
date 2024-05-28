import 'package:brewhelpy/service/firebase_options.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:brewhelpy/login.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final instance = FakeFirebaseFirestore();
  });


  testWidgets('Login screen should build its UI components correctly', (
      WidgetTester tester) async {
    final firestore = FakeFirebaseFirestore();

    //Arrange
    await tester.pumpWidget(MaterialApp(home: LoginScreen(true)));

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
    await tester.pumpWidget(MaterialApp(home: LoginScreen(true)));
    await tester.enterText(
        find.widgetWithText(TextField, 'Username'), 'testUser');
    await tester.enterText(
        find.widgetWithText(TextField, 'Password'), 'testPass');

    //Act
    await tester.tap(find.widgetWithText(ElevatedButton, 'Log In'));
    await tester.pump();
  });
}
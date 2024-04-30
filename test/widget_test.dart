// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:brewhelpy/new_recipe_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:brewhelpy/main.dart';

void main() {


  testWidgets('Filling Out New Recipe Form', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.byType(NewRecipeForm), findsOneWidget);

    // await tester.pumpWidget(const MaterialApp(
    //     home: Scaffold(
    //       body: NewRecipeForm()
    //     )
    // )
    // );

    await tester.enterText(find.byKey(const Key('Name')), 'Test Recipe');
    await tester.enterText(find.byKey(const Key('Brew Method')), 'French Press');
    await tester.enterText(find.byKey(const Key('Coffee Mass (in grams)')), '20');
    await tester.enterText(find.byKey(const Key('Brew Temperature (in Celsius)')), '95');
    await tester.enterText(find.byKey(const Key('Total Brew Time (in minutes)')), '120');
    await tester.enterText(find.byKey(const Key('Step 1')), 'Test');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text('Test Recipe added to recipes.'), findsOneWidget);
  });
}

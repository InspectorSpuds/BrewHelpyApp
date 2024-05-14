// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:brewhelpy/modify_recipe_form.dart';
import 'package:brewhelpy/new_recipe_form.dart';
import 'package:brewhelpy/service/database_handler.dart';
import 'package:brewhelpy/service/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:brewhelpy/main.dart';

void main() {


  testWidgets('Filling Out New Recipe Form', (WidgetTester tester) async {

    DbHandler handler = DbHandler();
    await tester.pumpWidget(MyApp(handler));
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    // await tester.pumpWidget(MaterialApp(
    //     home: Scaffold(
    //         body: NewRecipeForm(handler)
    //     )
    // )
    // );

    expect(find.byType(NewRecipeForm), findsOneWidget);


    await tester.enterText(find.byKey(const Key('Name')), 'Test Recipe');
    await tester.enterText(
        find.byKey(const Key('Brew Method')), 'French Press');
    await tester.enterText(
        find.byKey(const Key('Coffee Mass (in grams)')), '20');
    await tester.enterText(
        find.byKey(const Key('Brew Temperature (in Celsius)')), '95');
    await tester.enterText(
        find.byKey(const Key('Total Brew Time (in minutes)')), '120');
    await tester.enterText(find.byKey(const Key('Step 1')), 'Test');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text('Test Recipe added to recipes.'), findsOneWidget);
  });


  testWidgets('Test Add Step', (WidgetTester tester) async {
    DbHandler handler = DbHandler();
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: NewRecipeForm(handler)
        )
    )
    );

    await tester.tap(find.text('Add Step'));
    await tester.pump();
    expect(find.byKey(const Key('Step 2')), findsOneWidget);
  });

  testWidgets('Test Invalid Save', (WidgetTester tester) async {
    DbHandler handler = DbHandler();
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: NewRecipeForm(handler)
        )
    )
    );

    expect(find.byType(NewRecipeForm), findsOneWidget);


    await tester.enterText(find.byKey(const Key('Name')), 'Test Recipe');

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text('Quantity cannot be empty.'), findsWidgets);
  });

  testWidgets('Testing Modify Recipe Form', (WidgetTester tester) async {
    DbHandler handler = DbHandler();
    await tester.pumpWidget(MyApp(handler));

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    expect(find.byType(ModifyRecipeForm), findsOneWidget);

    await tester.enterText(find.byKey(const Key('Name')), '');
    await tester.enterText(find.byKey(const Key('Name')), 'Modified Recipe');
    await tester.enterText(find.byKey(const Key('Brew Method')), 'French Press');
    await tester.enterText(find.byKey(const Key('Coffee Mass (in grams)')), '30');
    await tester.enterText(find.byKey(const Key('Brew Temperature (in Celsius)')), '100');
    await tester.enterText(find.byKey(const Key('Total Brew Time (in minutes)')), '60');
    await tester.enterText(find.byKey(const Key('Step 1')), 'Test');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text('Modified Recipe modified.'), findsOneWidget);
  });


  testWidgets('Test Delete Step', (WidgetTester tester) async {
    DbHandler handler = DbHandler();
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: NewRecipeForm(handler)
        )
    )
    );

    expect(find.byType(NewRecipeForm), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump();

    expect(find.text('Step 1'), findsNothing);
  });
}
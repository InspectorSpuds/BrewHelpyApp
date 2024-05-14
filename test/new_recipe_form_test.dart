// Author: Kevin Bui
import 'package:brewhelpy/modify_recipe_form.dart';
import 'package:brewhelpy/new_recipe_form.dart';
import 'package:brewhelpy/service/database_handler.dart';
import 'package:brewhelpy/service/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:brewhelpy/main.dart';

void main() {
  // setUpAll(() async {
  //   await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  //   );
  // });



  testWidgets('Filling Out New Recipe Form', (WidgetTester tester) async {

    DbHandler handler = DbHandler();
    await handler.test();
    // await tester.pumpWidget(MyApp(handler));
    // await tester.tap(find.byIcon(Icons.add));
    //   await tester.pumpAndSettle();
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: NewRecipeForm(handler)
        )
    )
    );

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

    await tester.enterText(find.byKey(const Key('Water Weight 1 (grams)')), '120');
    await tester.enterText(find.byKey(const Key('Timestamp 1 (min:sec)')), '50:50');
    await tester.tap(find.text('Save'));
    await tester.pump();

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
    expect(find.byKey(const Key('Water Weight 2 (grams)')), findsOneWidget);
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



  testWidgets('Test Delete Step', (WidgetTester tester) async {
    DbHandler handler = DbHandler();
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: NewRecipeForm(handler)
        )
    )
    );

    expect(find.byType(NewRecipeForm), findsOneWidget);

    expect(find.text('Water Weight 1 (grams)'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump();

    expect(find.text('Water Weight 1 (grams)'), findsNothing);
  });
}
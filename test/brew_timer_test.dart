//Author: Ishan Parikh

import 'package:brewhelpy/models/app_state.dart';
import 'package:brewhelpy/service/firebase_options.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:brewhelpy/brew_timer.dart';
import 'package:provider/provider.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final instance = FakeFirebaseFirestore();
  });

  testWidgets('Brew Timer should start timer successfully', (WidgetTester tester) async {
    //Arrange
    var widget = BrewTimer();
    AppDetails dets = AppDetails();
    await tester.pumpWidget(MaterialApp(home: ChangeNotifierProvider<AppDetails>(
        create: (_) => dets,
        child: widget
    )
    ));


    //Act
    await tester.tap(find.widgetWithText(TextButton, "Start"));
    BrewTimerState state = tester.state(find.byWidget(widget));
    state.timer?.cancel();

    //Assert
    expect(state.timer, isNotNull);
  });

  testWidgets('Brew Timer should stop timer successfully after waiting', (WidgetTester tester) async {
    //Arrange
    var widget = BrewTimer();
    AppDetails dets = AppDetails();
    await tester.pumpWidget(MaterialApp(home: ChangeNotifierProvider<AppDetails>(
        create: (_) => dets,
        child: widget
    )
    ));

    //Act
    await tester.tap(find.widgetWithText(TextButton, "Start"));
    await tester.pump(const Duration(seconds: 10));
    await tester.tap(find.widgetWithText(TextButton, "Stop"));

    BrewTimerState state = tester.state(find.byWidget(widget));
    state.timer?.cancel();

    //Assert
    expect(state.timer, isNull);
  });
}
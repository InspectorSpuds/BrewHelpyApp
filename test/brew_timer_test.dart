//Author: Ishan Parikh

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:brewhelpy/brew_timer.dart';

void main() {
  testWidgets('Brew Timer should start timer successfully', (WidgetTester tester) async {
    //Arrange
    var widget = BrewTimer("");
    await tester.pumpWidget(MaterialApp(home: widget));

    //Act
    await tester.tap(find.widgetWithText(TextButton, "Start"));
    BrewTimerState state = tester.state(find.byWidget(widget));
    state.timer?.cancel();

    //Assert
    expect(state.timer, isNotNull);
  });

  testWidgets('Brew Timer should stop timer successfully after waiting', (WidgetTester tester) async {
    //Arrange
    var widget = BrewTimer("");
    await tester.pumpWidget(MaterialApp(home: widget));

    //Act
    await tester.tap(find.widgetWithText(TextButton, "Start"));
    await tester.pump(Duration(seconds: 10));
    await tester.tap(find.widgetWithText(TextButton, "Stop"));

    BrewTimerState state = tester.state(find.byWidget(widget));
    state.timer?.cancel();

    //Assert
    expect(state.timer, isNull);
  });
}
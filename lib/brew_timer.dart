import 'package:flutter/material.dart';

class BrewTimer extends StatefulWidget {
  final String recipeKey;

  const BrewTimer(this.recipeKey, {super.key});

  @override
  State<BrewTimer> createState() => _BrewTimerState();
}

class _BrewTimerState extends State<BrewTimer> {
  //timer variables
  int step = 0;
  String messageBoard = "Starting timer";
  Duration duration = Duration(minutes: 2, seconds: 2);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Step $step: $messageBoard"),
          TextButton(
              onPressed: () {

              },
              child: const Text("Start"),
          ),
        ]
      )
    );
  }
}

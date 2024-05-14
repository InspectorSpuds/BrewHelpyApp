//Author: ishan Parikh
import 'dart:async';
import 'package:flutter/material.dart';

class BrewTimer extends StatefulWidget {
  final String recipeKey;

  const BrewTimer(this.recipeKey, {super.key});

  @override
  State<BrewTimer> createState() => BrewTimerState();
}

class BrewTimerState extends State<BrewTimer> {
  //timer variables
  Timer? timer;
  List<Map<String, dynamic>> steps = [
    //note: the timestamps are when to add the mass by
    {
      "mass" : 50,
      "timestamp" : "0:30",
    },
    {
      "mass" : 100,
      "timestamp": "1:00"
    }
  ];
  int nextMinutes = 0;
  int nextSeconds = 0;

  int stopMinutes = 0;
  int stopSeconds = 0;

  //ui vars
  int step = 0;
  String messageBoard = "Start Brew when ready";
  int minutes = 0;
  int seconds = 0;

  void startTimer() {
    //get the final conditions
    setState(() {
      seconds = 0;
      minutes = 0;
    });

    step = 0;
    stopMinutes = int.parse(steps[steps.length - 1]['timestamp'].split(":")[0]);
    stopSeconds = int.parse(steps[steps.length - 1]['timestamp'].split(":")[1]);

    //get next goalpost if exists
    nextMinutes = int.parse(steps[step]['timestamp'].split(":")[0]);
    nextSeconds = int.parse(steps[step]['timestamp'].split(":")[1]);
    messageBoard = "Add to ${steps[step]['mass']}g by ${steps[step]['timestamp']}";

    //set periodic time
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTimer());
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
    setState(() {
      messageBoard = "Start Brew when ready";
      seconds = 0;
      minutes = 0;
    });
  }

  void addTimer() {
    setState(() {
      seconds++;

      if(seconds >= 60) {
        seconds = 0;
        minutes++;
      }

      //if step post reached
      if(minutes == nextMinutes && seconds == nextSeconds) {
        moveToNextStep();
      }

      //stop timer at final step
      if(minutes == stopMinutes && seconds == stopSeconds + 1) {
        messageBoard = "You finished the brew!";
        stopTimer();
      }
    });
  }

  void moveToNextStep() {
    step++;

    //only update if more steps left
    if(step < steps.length) {
      nextMinutes = int.parse(steps[step]['timestamp'].split(":")[0]);
      nextSeconds = int.parse(steps[step]['timestamp'].split(":")[1]);
      messageBoard = "Add to ${steps[step]['mass']}g by ${steps[step]['timestamp']}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //The next step
          Text(messageBoard, style: const TextStyle(fontSize: 25),),
          const SizedBox(
            height: 50,
          ),
          //the timer board
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("$minutes", style: const TextStyle(fontSize: 25)),
                const Text(":", style: TextStyle(fontSize: 25)),
                Text("$seconds", style: const TextStyle(fontSize: 25)),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  startTimer();
                },
                child: const Text("Start"),
              ),
              TextButton(
                  onPressed: () {
                    stopTimer();
                  },
                  child: const Text("Stop")
              )
            ],
          )

        ]
      )
    );
  }
}

//Author: ishan Parikh
import 'dart:async';
import 'package:brewhelpy/service/notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/app_state.dart';

class BrewTimer extends StatefulWidget {
  const BrewTimer({super.key});

  @override
  State<BrewTimer> createState() => BrewTimerState();
}

class BrewTimerState extends State<BrewTimer> {
  //timer variables
  Timer? timer;
  // Initialize push notification service
  Notifier notifier = Notifier();

  String _recipeName = "None";

  List<Map<String, dynamic>> steps = [
    //note: the timestamps are when to add the mass by

    {"mass": "unlimited", "timestamp": "99:00"}
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
    messageBoard =
        "Add to ${steps[step]['mass']}g by ${steps[step]['timestamp']}";

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

      if (seconds >= 60) {
        seconds = 0;
        minutes++;
      }

      //if step post reached
      if (minutes == nextMinutes && seconds == nextSeconds) {
        moveToNextStep();
      }

      //stop timer at final step
      if (minutes == stopMinutes && seconds == stopSeconds + 1) {
        messageBoard = "You finished the brew!";
        stopTimer();
      }
    });
  }

  void moveToNextStep() {
    step++;

    //only update if more steps left
    if (step < steps.length) {
      nextMinutes = int.parse(steps[step]['timestamp'].split(":")[0]);
      nextSeconds = int.parse(steps[step]['timestamp'].split(":")[1]);
      messageBoard =
          "Add to ${steps[step]['mass']}g by ${steps[step]['timestamp']}";

      // Send a push notification
      notifier.showNextStep(_recipeName, steps[step]['timestamp'], steps[step]['mass']);
    }
  }

  void finishBrew() {

  }

  @override
  void initState() {
    super.initState();

    // Initialize push notifications
    WidgetsBinding.instance.addPostFrameCallback((_){
      notifier.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    //if the user id is null, require login

    return Center(
      child: Consumer<AppDetails>(builder: (context, provider, child) {
         return provider.recipeKey == "" ?
         // Free usage mode
         Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //The next step
              Text(
                messageBoard,
                style: const TextStyle(fontSize: 25),
              ),
              const SizedBox(
                height: 50,
              ),
              //the timer board
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("$minutes",
                        style: const TextStyle(fontSize: 25)),
                    const Text(":", style: TextStyle(fontSize: 25)),
                    Text("$seconds",
                        style: const TextStyle(fontSize: 25)),
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
                    onPressed: () async {
                      await notifier.showNextStep(_recipeName, steps[step]['timestamp'],
                          steps[step]['mass'].runtimeType == String ? 0 : steps[step]['mass']);
                      startTimer();
                    },
                    child: const Text("Start"),
                  ),
                  TextButton(
                      onPressed: () {
                        stopTimer();
                      },
                      child: const Text("Stop"))
                ],
              )
            ])
         // Use a specific recipe key
        : StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Recipes')
                .where(FieldPath.documentId, isEqualTo: provider.recipeKey)
                .snapshots(),
            builder: (BuildContext context, var snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              if (!snapshot.hasData) return const Text('no data');
              var data = snapshot.data?.docs[0];
              _recipeName = data?['name'];

              // add the steps to the steps array
              steps = [];
              for(var step in data?['steps']) {
                steps.add({
                  "mass" :     step['waterWeight'],
                  "timestamp": step['timestamp'],
                });
              }

              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //The next step
                    Container(
                      color: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.all(20),
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Column(
                        children: [
                          Text(
                            "Recipe: ${data?['name']}",
                            style: TextStyle(fontSize: 28, color: Theme.of(context).secondaryHeaderColor),
                          ),
                          Text(
                              "Brew Method: ${data?['brewMethod']}",
                            style: TextStyle(fontSize: 22, color: Theme.of(context).secondaryHeaderColor),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(3),
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.lightBlueAccent,
                                      border: Border.all(color: Colors.lightBlueAccent),
                                      borderRadius: const BorderRadius.all(Radius.circular(20))
                                  ),
                                  child: Text("${steps[steps.length - 1]['mass']} grams",)
                              ),
                              Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      border: Border.all(color: Colors.red),
                                      borderRadius: const BorderRadius.all(Radius.circular(20))
                                  ),
                                  child: Text("${data?['temperature']['brewTemp']} ${data?['temperature']['units'] == "Celsius" ? "C" : "F"}", )
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                    const Spacer(
                      flex: 2,
                    ),
                    Text(
                      messageBoard,
                      style: const TextStyle(fontSize: 25),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    //the timer board
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("$minutes",
                              style: const TextStyle(fontSize: 25)),
                          const Text(":", style: TextStyle(fontSize: 25)),
                          Text("$seconds",
                              style: const TextStyle(fontSize: 25)),
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
                          onPressed: () async {
                            await notifier.showNextStep(_recipeName, steps[step]['timestamp'],
                                steps[step]['mass'].runtimeType == String ? 0 : steps[step]['mass']);

                            startTimer();
                          },
                          child: const Text("Start"),
                        ),
                        TextButton(
                            onPressed: () {
                              stopTimer();
                            },
                            child: const Text("Stop"))
                      ],
                    ),
                    const Spacer(),
                    TextButton(
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(Colors.red),
                      ),
                      onPressed: () {
                        // Reset recipe key
                        provider.updateRecipe("");

                        finishBrew();
                      },
                      child: const Text("Finish Brew", style: TextStyle(color: Colors.white),),
                    )
                  ]);
            });
      }),
    );
  }
}

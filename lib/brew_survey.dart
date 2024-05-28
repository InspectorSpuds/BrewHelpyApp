// author: ishan parikh
import 'package:brewhelpy/modify_recipe_form.dart';
import 'package:brewhelpy/service/database_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/app_state.dart';

class BrewSurvey extends StatefulWidget {
  const BrewSurvey({super.key});

  @override
  State<StatefulWidget> createState() => _BrewSurveyState();
}

class _BrewSurveyState extends State<BrewSurvey> {
  double _currentSliderValue = 2;

  void navigateToRecipeEditForm() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ModifyRecipeForm(adjustmentScale: _currentSliderValue)));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppDetails>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              title: const Text("Brew Survey"),
            ),
            body: Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          border: Border.all(color: Theme.of(context).primaryColor),
                          borderRadius: const BorderRadius.all(Radius.circular(20))
                      ),
                      child: Text(
                        "How was your Brew?",
                        style: TextStyle(fontSize: 28, color: Theme.of(context).secondaryHeaderColor),
                      ),
                    ),
                    const Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Slider(
                          activeColor: Colors.red,
                          inactiveColor: Theme.of(context).secondaryHeaderColor,
                          thumbColor: Theme.of(context).primaryColor,
                          value: _currentSliderValue,
                          max: 4,
                          divisions: 4,
                          label: _currentSliderValue.round().toString(),
                          onChanged: (double value) {
                            setState(() {
                              _currentSliderValue = value;
                            });
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Sour"),
                              Spacer(),
                              Text("Just Right!"),
                              Spacer(),
                              Text("Bitter"),
                            ],
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(Theme.of(context).primaryColor),
                      ),
                      onPressed: () async{
                        navigateToRecipeEditForm();
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                    ),
                  ],
                )
            ),
          );
        }
    );
  }
}
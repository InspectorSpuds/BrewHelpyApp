import 'package:brewhelpy/form_action_buttons.dart';
import 'package:brewhelpy/recipe_steps.dart';
import 'package:brewhelpy/service/database_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:brewhelpy/recipe.dart';
import 'package:brewhelpy/quantity_field.dart';

import 'name_field.dart';

class NewRecipeForm extends StatefulWidget {
  DbHandler _handler;
  NewRecipeForm(this._handler, {super.key});

  @override
  State<NewRecipeForm> createState() => _NewRecipeFormState();
}

class _NewRecipeFormState extends State<NewRecipeForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brewMethodController = TextEditingController();
  final _coffeeMassController = TextEditingController();
  final _brewTempController = TextEditingController();
  final _totalTimeController = TextEditingController();
  final _waterWeightControllers = <TextEditingController>[TextEditingController()];
  final _timestampControllers = <TextEditingController>[TextEditingController()];

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _brewMethodController.dispose();
    _coffeeMassController.dispose();
    _brewTempController.dispose();
    _totalTimeController.dispose();
    for (final controller in _waterWeightControllers) {
      controller.dispose();
    }
    for (final controller in _timestampControllers) {
      controller.dispose();
    }
  }

  void _addStep() {
    setState(() {
      _waterWeightControllers.add(TextEditingController());
      _timestampControllers.add(TextEditingController());
    });
  }

  void _deleteStep(int index){
    setState(() {
      _waterWeightControllers.removeAt(index);
      _timestampControllers.removeAt(index);
    });
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final List<RecipeStep> steps = List.generate(
          _waterWeightControllers.length,
              (index) => RecipeStep(
            waterWeight: int.parse(_waterWeightControllers[index].text),
            timestamp: _timestampControllers[index].text,
          )

      );

      final newRecipe = Recipe(
        name: _nameController.text,
        brewMethod: _brewMethodController.text,
        coffeeMass: int.parse(_coffeeMassController.text),
        brewTemp: int.parse(_brewTempController.text),
        totalTime: int.parse(_totalTimeController.text),
        steps: steps,
      );

      // need to add to database from here
      widget._handler.addRecipe(newRecipe);
      // FirebaseFirestore.instance.collection('Recipe').add({
      //   'brewMethod': {
      //     'units': 'Celsius',
      //     'value': newRecipe.brewMethod,
      //     'brewTemp':newRecipe.brewTemp,
      //   },
      //   'coffeeMass': newRecipe.coffeeMass,
      //   'name': newRecipe.name,
      //   'totalTime': "$newRecipe.totalTime",
      //   'userID':
      //       "null", //for now we're keeping it null till we connect our login form
      //   'steps': steps.map((step) => {
      //     'waterWeight': step.waterWeight,
      //     'timestamp': step.timestamp,
      //   }).toList(),
      // });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_nameController.text} added to recipes.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(
              children: [
                NameField(nameController: _nameController, label: 'Name'),
                NameField(nameController: _brewMethodController, label: 'Brew Method'),
                QuantityField(quantityController:  _coffeeMassController, label: 'Coffee Mass (in grams)'),
                QuantityField(quantityController: _brewTempController, label: 'Brew Temperature (in Celsius)'),
                QuantityField(quantityController: _totalTimeController, label: 'Total Brew Time (in minutes)'),
                ActionButtons(onSave: _onSave,),
                ..._waterWeightControllers.asMap().entries.map(
                        (controller) => Row(
                        children: [
                          Expanded(
                            child: QuantityField(quantityController:
                            controller.value,
                                label: 'Water Weight ${controller.key + 1} (grams)'),
                          ),
                          Expanded(
                            child: NameField(nameController:
                            _timestampControllers[controller.key],
                                label: 'Timestamp ${controller.key + 1} (min:sec)'),
                          ),
                          IconButton(
                              onPressed: () => _deleteStep(controller.key),
                              icon: const Icon(Icons.delete))
                        ]
                    )
                ),
                ElevatedButton(
                  onPressed: _addStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,),
                  child: const Text('Add Step'),
                )
              ],
            )


        )
    );
  }
}
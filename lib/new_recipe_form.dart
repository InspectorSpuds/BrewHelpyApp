import 'package:brewhelpy/form_action_buttons.dart';
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
  final _stepsControllers = <TextEditingController>[TextEditingController()];

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _brewMethodController.dispose();
    _coffeeMassController.dispose();
    _brewTempController.dispose();
    _totalTimeController.dispose();
    for (final controller in _stepsControllers) {
      controller.dispose();
    }
  }

  void _addStep() {
    setState(() {
      _stepsControllers.add(TextEditingController());
    });
  }

  void _deleteStep(int index){
    setState(() {
      _stepsControllers.removeAt(index);
    });
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final List<String> steps =
          _stepsControllers.map((controller) => controller.text).toList();

      final newRecipe = Recipe(
        name: _nameController.text,
        brewMethod: _brewMethodController.text,
        coffeeMass: int.parse(_coffeeMassController.text),
        brewTemp: int.parse(_brewTempController.text),
        totalTime: int.parse(_totalTimeController.text),
        steps: steps,
      );

      // need to add to database from here
      FirebaseFirestore.instance.collection('Recipe').add({
        'brewMethod': {
          'units': 'Celsius',
          'value': newRecipe.brewMethod,
        },
        'coffeeMass': newRecipe.coffeeMass,
        'name': newRecipe.name,
        'totalTime': "$newRecipe.totalTime",
        'userID':
            "null" //for now we're keeping it null till we connect our login form
      });

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
                ..._stepsControllers.asMap().entries.map(
                        (controller) => Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                key: Key('Step ${controller.key + 1}'),
                                decoration: InputDecoration(
                                  labelText: 'Step ${controller.key + 1}',
                                ),
                                controller: controller.value,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Step cannot be empty.';
                                  }
                                  return null;
                                },
                              ),
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

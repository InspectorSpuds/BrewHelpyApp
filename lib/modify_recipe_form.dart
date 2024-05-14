
import 'package:brewhelpy/quantity_field.dart';
import 'package:brewhelpy/form_action_buttons.dart';
import 'package:brewhelpy/recipe.dart';
import 'package:brewhelpy/service/database_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'name_field.dart';

class ModifyRecipeForm extends StatefulWidget {
  DbHandler _handler;
  ModifyRecipeForm(this._handler, {super.key});

  // retrieve recipe from database

  @override
  State<ModifyRecipeForm> createState() => _ModifyRecipeFormState();
}

class _ModifyRecipeFormState extends State<ModifyRecipeForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Recipe _recipe;
  // REPLACE THIS WITH DATABASE RETRIEVE, EXAMPLE TO TEST IF IT WORKED
  ///////////////////////////////////////////////////////////////////
  List<String> steps = ['Step 1'];
  late final TextEditingController _nameController = TextEditingController(text: "Name");
  late final TextEditingController _brewMethodController = TextEditingController(text: "Method");
  late final TextEditingController _coffeeMassController = TextEditingController(text: 1.toString());
  late final TextEditingController _brewTempController = TextEditingController(text: 2.toString());
  late final TextEditingController _totalTimeController = TextEditingController(text: 3.toString());
  late final List<TextEditingController> _stepsControllers = steps.map((step) => TextEditingController(text: step)).toList();



  void _addStep(){
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
    if(_formKey.currentState?.validate() ?? false) {
      final List<String> steps =
      _stepsControllers.map((controller) => controller.text).toList();

      final newRecipe = Recipe(
        name: _nameController.text,
        brewMethod: _brewMethodController.text,
        coffeeMass: int.parse(_coffeeMassController.text),
        brewTemp: int.parse(_brewTempController.text),
        totalTime: int.parse(_totalTimeController.text),
        steps: [],
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${_nameController.text} modified.')
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if(_recipe == null){
      return const CircularProgressIndicator();
    }
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(
              children: [
                NameField(nameController: TextEditingController(text: _recipe.name), label: 'Name'),
                NameField(nameController: TextEditingController(text: _recipe.brewMethod), label: 'Brew Method'),
                QuantityField(quantityController:  TextEditingController(text: _recipe.coffeeMass.toString()), label: 'Coffee Mass (in grams)'),
                QuantityField(quantityController: TextEditingController(text: _recipe.brewTemp.toString()), label: 'Brew Temperature (in Celsius)'),
                QuantityField(quantityController: TextEditingController(text: _recipe.totalTime.toString()), label: 'Total Brew Time (in minutes)'),
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
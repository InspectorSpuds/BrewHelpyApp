
import 'package:brewhelpy/quantity_field.dart';
import 'package:brewhelpy/form_action_buttons.dart';
import 'package:brewhelpy/recipe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'name_field.dart';

class ModifyRecipeForm extends StatefulWidget {
  const ModifyRecipeForm({super.key});

  // retrieve recipe from database

  @override
  State<ModifyRecipeForm> createState() => _ModifyRecipeFormState();
}

class _ModifyRecipeFormState extends State<ModifyRecipeForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // REPLACE THIS WITH DATABASE RETRIEVE

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

  void _onSave() {
    if(_formKey.currentState?.validate() ?? false) {
      final List<String> steps = _stepsControllers.map((controller) => controller.text).toList();

      final newRecipe = Recipe(
        name: _nameController.text,
        brewMethod: _brewMethodController.text,
        coffeeMass: int.parse(_coffeeMassController.text),
        brewTemp: int.parse(_brewTempController.text),
        totalTime: int.parse(_totalTimeController.text),
        steps: steps,
      );

      // need to add to database from here


      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${_nameController.text} modified.')
      ));
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
                ..._stepsControllers.map((controller){
                  int index = _stepsControllers.indexOf(controller);
                  return TextFormField(
                    key: Key('Step ${index + 1}'),
                    decoration: InputDecoration(
                      labelText: 'Step ${index + 1}',
                    ),
                    controller: controller,
                    validator: (value) {
                      if(value == null || value.trim().isEmpty){
                        return 'Step cannot be empty.';
                      }
                      return null;
                    },
                  );
                }
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

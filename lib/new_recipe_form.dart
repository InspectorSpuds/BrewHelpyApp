//Author: Kevin Bui
import 'package:brewhelpy/form_action_buttons.dart';
import 'package:brewhelpy/models/app_state.dart';
import 'package:brewhelpy/models/recipe_steps.dart';
import 'package:brewhelpy/service/database_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:brewhelpy/models/recipe.dart';
import 'package:brewhelpy/quantity_field.dart';
import 'package:provider/provider.dart';

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

  void _onSave(func) {
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

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_nameController.text} added to recipes.')));
      func(0);
    }
  }

  @override
  void initState() {
    if(!widget._handler.isInitialized) {
      widget._handler.init();
    }
  }

  @override
  Widget build(BuildContext context) {
    if(FirebaseAuth.instance.currentUser == null) {
      return const Center(
        child: Text("Login is required to use this feature"),
      );
    }

    return Consumer<AppDetails>(
      builder: (context, provider, child) {
        return Form(
            canPop: false,
            key: _formKey,
            child: SingleChildScrollView(
                child: Column(
                  children: [
                    NameField(nameController: _nameController, label: 'Name'),
                    NameField(nameController: _brewMethodController, label: 'Brew Method'),
                    QuantityField(quantityController:  _coffeeMassController, label: 'Coffee Mass (in grams)'),
                    QuantityField(quantityController: _brewTempController, label: 'Brew Temperature (in Celsius)'),
                    QuantityField(quantityController: _totalTimeController, label: 'Total Brew Time (in minutes)'),
                    ActionButtons(onSave: () {
                      _onSave(provider.updatePage);
                    },),
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
    );
  }
}
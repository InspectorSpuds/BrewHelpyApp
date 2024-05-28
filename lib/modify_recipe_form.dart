
import 'package:brewhelpy/quantity_field.dart';
import 'package:brewhelpy/form_action_buttons.dart';
import 'package:brewhelpy/models/recipe.dart';
import 'package:brewhelpy/service/database_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'models/app_state.dart';
import 'models/recipe_steps.dart';
import 'name_field.dart';

class ModifyRecipeForm extends StatefulWidget {
  double adjustmentScale;
  ModifyRecipeForm({super.key, required this.adjustmentScale});

  // retrieve recipe from database

  @override
  State<ModifyRecipeForm> createState() => _ModifyRecipeFormState();
}

class _ModifyRecipeFormState extends State<ModifyRecipeForm> {

  late Recipe _recipe;
  late DbHandler handler;
  // REPLACE THIS WITH DATABASE RETRIEVE, EXAMPLE TO TEST IF IT WORKED
  ///////////////////////////////////////////////////////////////////
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _brewMethodController = TextEditingController();
  TextEditingController _coffeeMassController = TextEditingController();
  TextEditingController _brewTempController = TextEditingController();
  TextEditingController _totalTimeController = TextEditingController();
  final _waterWeightControllers = <TextEditingController>[TextEditingController()];
  final _timestampControllers = <TextEditingController>[TextEditingController()];


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

  void _onSave(AppDetails p) {
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
        coffeeMass: int.parse(_coffeeMassController.text.trim()),
        brewTemp: int.parse(_brewTempController.text),
        totalTime: int.parse(_totalTimeController.text),
        steps: steps,
      );

      handler = DbHandler();
      handler.init();

      // need to add to database from here
      handler.editRecipe(p.recipeKey, newRecipe);

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_nameController.text} recipe modified!')));

      p.updatePage(0);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyHomePage(handler,  title: 'BrewHelpy')),  (route) => false);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Modify recipe"),
      ),
      body: Form(
          key: _formKey,
          child:  Consumer<AppDetails>(
            builder: (context, provider, child){
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Recipes').where(FieldPath.documentId, isEqualTo: provider.recipeKey).snapshots(),
                builder: (BuildContext context, var snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  if (!snapshot.hasData) return const Text('no data');
                  var data = snapshot.data?.docs[0];

                  List<RecipeStep> steps = [];
                  _waterWeightControllers.clear();
                  _timestampControllers.clear();
                  for(var step in data?['steps']) {
                    steps.add(new RecipeStep(waterWeight: step?['waterWeight'], timestamp: step?['timestamp']));
                    print("${step?['waterWeight']} ${step?['timestamp']}");
                    _waterWeightControllers.add(TextEditingController(text: '${step?['waterWeight']}'));
                    _timestampControllers.add(TextEditingController(text: step?['timestamp']));
                  }

                  // Set recipe
                  _recipe = Recipe(
                    name: data?['name'],
                    brewMethod: data?['brewMethod'],
                    coffeeMass: data?['coffeeMass'],
                    brewTemp: data?['temperature']['brewTemp'],
                    totalTime: int.parse(data?['totalTime']),
                    steps: steps,
                  );

                  _nameController = TextEditingController(text: _recipe.name);
                  _brewMethodController = TextEditingController(text: _recipe.brewMethod);
                  _coffeeMassController = TextEditingController(text: '${data?['coffeeMass']}');
                  _brewTempController = TextEditingController(text: '${data?['temperature']['brewTemp'] - ((widget.adjustmentScale-2) * 2)}');
                  _totalTimeController = TextEditingController(text: data?['totalTime']);

                  return SingleChildScrollView(
                      child: Column(
                        children: [
                          Text("Here's what we think is best"),
                          NameField(nameController: _nameController, label: 'Name'),
                          NameField(nameController: _brewMethodController, label: 'Brew Method'),
                          QuantityField(quantityController:  _coffeeMassController, label: 'Coffee Mass (in grams)'),
                          QuantityField(quantityController: _brewTempController, label: 'Brew Temperature (in Celsius)'),
                          QuantityField(quantityController: _totalTimeController, label: 'Total Brew Time (in minutes)'),
                          ActionButtons(onSave: () {
                            _onSave(provider);
                            },
                          ),
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
                  );
              }
            );
          }
          )
      ),
    );
  }
}
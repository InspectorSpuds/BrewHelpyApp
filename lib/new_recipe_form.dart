import 'package:flutter/material.dart';
import 'package:brewhelpy/recipe.dart';

class NewRecipeForm extends StatefulWidget {

  const NewRecipeForm({super.key});

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


  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _brewMethodController.dispose();
    _coffeeMassController.dispose();
    _brewTempController.dispose();
    _totalTimeController.dispose();
  }


  void _onSave() {
    if(_formKey.currentState?.validate() ?? false) {
      final newRecipe = Recipe(
        name: _nameController.text,
        brewMethod: _brewMethodController.text,
        coffeeMass: int.parse(_coffeeMassController.text),
        brewTemp: int.parse(_brewTempController.text),
        totalTime: int.parse(_totalTimeController.text),

      );

      // need to add to database from here


      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${_nameController.text} added to recipes.')
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
                _NameField(_nameController),
                _QuantityField(_brewMethodController, 'Brew Method'),
                _QuantityField(_coffeeMassController, 'Coffee Mass'),
                _QuantityField(_brewTempController, 'Brew Temperature'),
                _QuantityField(_totalTimeController, 'Total Brew Time (in minutes)'),
                _ActionButtons(_onSave),
              ],
            )
        )
    );
  }
}

class _NameField extends StatelessWidget {
  final TextEditingController nameController;
  const _NameField(this.nameController);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
          labelText: 'Name'
      ),
      controller: nameController,
      validator: (value) {
        if(value == null || value.trim().isEmpty) {
          return 'Name cannot be empty.';
        }
        return null;
      },
    );
  }
}



class _QuantityField extends StatelessWidget {
  final TextEditingController quantityController;
  final String label;
  const _QuantityField(this.quantityController, this.label);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          labelText: label
      ),
      keyboardType: TextInputType.number,
      controller: quantityController,
      validator: (value) {
        if(value == null || value.trim().isEmpty) {
          return 'Quantity cannot be empty.';
        }
        int? asInt = int.tryParse(value);
        if(asInt == null) {
          return 'Quantity must be a whole number.';
        }
        if(asInt <= 0) {
          return 'Quantity must be positive.';
        }
        return null;
      },
    );
  }
}


class _ActionButtons extends StatelessWidget {
  final void Function() onSave;
  const _ActionButtons(this.onSave);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OutlinedButton(
          onPressed: () { Navigator.pop(context); },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: onSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
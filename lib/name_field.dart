import 'package:flutter/material.dart';
import 'package:brewhelpy/models/recipe.dart';

class NameField extends StatelessWidget {
  final TextEditingController nameController;
  const NameField({super.key, required this.nameController, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: Key(label),
      decoration:InputDecoration(
          labelText: label
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
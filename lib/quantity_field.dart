import 'package:flutter/material.dart';

class QuantityField extends StatelessWidget {
  final TextEditingController quantityController;
  final String label;

  const QuantityField({super.key, required this.quantityController, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: Key(label),
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
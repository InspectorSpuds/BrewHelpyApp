import 'package:flutter/material.dart';
import 'package:brewhelpy/recipe.dart';

class ActionButtons extends StatelessWidget {
  final void Function() onSave;
  const ActionButtons({super.key, required this.onSave});


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
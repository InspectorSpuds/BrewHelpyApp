import 'package:brewhelpy/models/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActionButtons extends StatelessWidget {
  final void Function() onSave;
  const ActionButtons({super.key, required this.onSave});


  @override
  Widget build(BuildContext context) {
    return Consumer<AppDetails>(
      builder: (context, provider, child)  {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(
              onPressed: () { provider.updatePage(0);},
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
    );
  }
}
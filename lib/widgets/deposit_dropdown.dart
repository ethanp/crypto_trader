import 'package:flutter/material.dart';

class DepositDropdown extends StatelessWidget {
  const DepositDropdown(this.dropdownValue, {required this.dropdownChanged});

  final DropdownValue dropdownValue;
  final void Function(int) dropdownChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 55,
      child: DropdownButtonFormField<int>(
        value: dropdownValue.wrappedInt,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[800],
        ),
        icon: const Icon(Icons.attach_money),
        enableFeedback: true,
        iconSize: 16,
        onChanged: (int? newValue) => dropdownChanged(newValue!),
        items: [
          for (final dropdownValue in [10, 20, 50])
            DropdownMenuItem(
              value: dropdownValue,
              child: Text(dropdownValue.toString()),
            )
        ],
      ),
    );
  }
}

class DropdownValue {
  DropdownValue(this.wrappedInt);

  int wrappedInt;
}

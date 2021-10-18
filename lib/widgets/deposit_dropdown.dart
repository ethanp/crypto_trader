import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DepositDropdown extends StatelessWidget {
  const DepositDropdown(this.selectedDropdownValue);

  final int selectedDropdownValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 55,
      child: DropdownButtonFormField<int>(
        value: selectedDropdownValue,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[800],
        ),
        enableFeedback: true,
        iconSize: 16,
        onChanged: (int? newValue) {
          final state = context.read<DepositCardState>();
          state.changeDropdownValue(newValue!);
        },
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

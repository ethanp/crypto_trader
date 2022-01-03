// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountField extends StatelessWidget {
  const AmountField(this.fieldController);

  /// Captures the user's input into the field for use in the [TransactButton].
  final TextEditingController fieldController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: TextFormField(
        controller: fieldController,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          errorStyle: TextStyle(color: Colors.red[500]),
          fillColor: Colors.grey[800]!.withOpacity(0.7),
          filled: true,
          labelText: '\$ Amount',
          labelStyle: TextStyle(color: Colors.green[200]),
          isDense: true,
          contentPadding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
        ),
        textAlign: TextAlign.right,
        validator: validateAmount,
        autovalidateMode: AutovalidateMode.always,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        // These are called before `onChanged:`
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[\.0-9]')),
          LengthLimitingTextInputFormatter(5),
        ],
      ),
    );
  }

  /// Runs a few sanity checks on the input.
  /// Returns an error string if the input is invalid.
  static String? validateAmount(String? input) {
    if (input == null || input.isEmpty)
      return 'Enter amount';
    else if (double.tryParse(input) == null)
      return 'Not \$';
    else if (double.parse(input) < 10)
      return 'at least \$10';
    else if (double.parse(input) >= 100)
      return 'under \$100';
    else if (input.indexOf('.') < input.length - 3)
      return 'Not \$';
    else
      return null;
  }
}

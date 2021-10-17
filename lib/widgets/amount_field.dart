// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom [TextField] for this project that pairs with a [SpendButton]
/// and [TransferRow] to allow the user to select an amount and then conduct
/// a financial transaction.
///
/// It is given a [TextEditingController] that it shares with the [SpendButton].
class AmountField extends StatelessWidget {
  /// Custom [TextField] for this project that pairs with a [SpendButton]
  /// and [TransferRow] to allow the user to select an amount and then conduct
  /// a financial transaction.
  ///
  /// It is given a [TextEditingController] that it shares with the [SpendButton].
  const AmountField(this.fieldController);

  /// Shared with the [SpendButton] and [TransferRow].
  /// In this class, it captures the user's input into the field.
  final TextEditingController fieldController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: 80,
      child: TextFormField(
        controller: fieldController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: '\$ Amount',
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
        textAlign: TextAlign.center,
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
      return 'Empty';
    else if (double.tryParse(input) == null)
      return 'Not \$';
    else if (double.parse(input) < 10)
      return '≥\$10';
    else if (double.parse(input) >= 100)
      return '<\$100';
    else if (input.indexOf('.') < input.length - 3)
      return 'Not \$';
    else
      return null;
  }
}

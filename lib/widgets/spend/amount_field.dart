import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountField extends StatelessWidget {
  final TextEditingController fieldController;

  const AmountField(this.fieldController);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: TextFormField(
        controller: fieldController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: '\$ Amount',
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
        textAlign: TextAlign.center,
        validator: validateInput,
        autovalidateMode: AutovalidateMode.always,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        // These are called before `onChanged:`
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[\.0-9]')),
          LengthLimitingTextInputFormatter(5),
        ],
      ),
    );
  }

  static String? validateInput(String? input) {
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

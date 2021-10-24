import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DepositDropdown extends StatelessWidget {
  const DepositDropdown(this.selectedDropdownValue);

  final String selectedDropdownValue;

  @override
  Widget build(BuildContext context) => SizedBox(
      width: 80,
      height: 48,
      child: Stack(children: [_dropdown(context), _label()]));

  Widget _dropdown(BuildContext context) => Positioned(
        top: 7,
        child: SizedBox(
          width: 80,
          height: 38,
          child: DropdownButtonFormField<int>(
            value: int.parse(selectedDropdownValue),
            decoration: InputDecoration(
              filled: true,
              isDense: true,
              fillColor: Colors.grey[800]!.withOpacity(0.8),
            ),
            enableFeedback: true,
            iconSize: 16,
            itemHeight: 70,
            onChanged: (int? newValue) =>
                context.read<DepositCardValue>().value = newValue!.toString(),
            items: _dropdownItems(),
          ),
        ),
      );

  List<DropdownMenuItem<int>> _dropdownItems() => [
        for (final dropdownValue in [10, 20, 50])
          DropdownMenuItem(
            value: dropdownValue,
            child: Text(dropdownValue.toString()),
          )
      ];

  Widget _label() => Text('\$ Amount',
      style: TextStyle(color: Colors.green[200], fontSize: 12));
}

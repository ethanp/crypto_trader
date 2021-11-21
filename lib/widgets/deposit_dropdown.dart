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
      child: Stack(children: [
        _dropdown(context),
        _label(),
      ]));

  Widget _dropdown(BuildContext context) => Positioned(
      top: 7,
      child: SizedBox(
          width: 75,
          child: DropdownButtonFormField<int>(
              value: int.parse(selectedDropdownValue),
              decoration: InputDecoration(
                  filled: true,
                  isDense: true,
                  // TODO combine with the amount_field.dart one doing same thing
                  fillColor: Colors.grey[800]!.withOpacity(0.7)),
              enableFeedback: true,
              iconSize: 16,
              onChanged: (int? newValue) =>
                  context.read<DepositCardValue>().value = newValue!.toString(),
              items: _dropdownItems())));

  List<DropdownMenuItem<int>> _dropdownItems() => [10, 20, 50]
      .map((v) => DropdownMenuItem(value: v, child: Text(v.toString())))
      .toList();

  Widget _label() => Text('\$ Amount',
      style: TextStyle(color: Colors.green[200], fontSize: 12));
}

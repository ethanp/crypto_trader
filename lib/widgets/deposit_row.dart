import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';

class DepositRow extends StatefulWidget {
  @override
  _DepositRowState createState() => _DepositRowState();
}

class _DepositRowState extends State<DepositRow> {
  DropdownValue dropdownValue = DropdownValue(10);

  @override
  Widget build(BuildContext context) {
    return WithHoldings(
      builder: (holdings) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DepositDropdown(
              dropdownValue,
              dropdownChanged: (value) =>
                  setState(() => dropdownValue.wrappedInt = value),
            ),
            const SizedBox(width: 20),
            TransactButton(
              Environment.trader.deposit,
              'Deposit Dollars',
              dropdownValue.wrappedInt.toString(),
            ),
          ],
        );
      },
    );
  }
}

class DepositDropdown extends StatelessWidget {
  const DepositDropdown(this.dropdownValue, {required this.dropdownChanged});

  final DropdownValue dropdownValue;
  final void Function(int) dropdownChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 55,
      child: Column(
        children: [
          DropdownButtonFormField<int>(
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
        ],
      ),
    );
  }
}

class DropdownValue {
  DropdownValue(this.wrappedInt);

  int wrappedInt;
}

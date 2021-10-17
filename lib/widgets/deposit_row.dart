import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';

class DepositRow extends StatefulWidget {
  @override
  _DepositRowState createState() => _DepositRowState();
}

class _DepositRowState extends State<DepositRow> {
  DropdownValue dropdownValue = DropdownValue(50);

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

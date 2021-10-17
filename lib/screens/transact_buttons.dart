import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';

/// Area of the screen with the cash available, deposit, and spend Widgets.
class TransactButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(children: [
        DepositRow(),
        SpendRow(),
      ]),
    );
  }
}

import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';

/// Area of the screen with the cash available, deposit, and spend Widgets.
class TransactButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.only(top: 2, bottom: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DepositCard(),
            SpendCard(),
          ],
        ),
      ),
    );
  }
}

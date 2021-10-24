import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';

class TransactButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(children: [
        _cashAvailable(),
        _transactionCards(),
      ]);

  Widget _cashAvailable() => WithHoldings(
      builder: (holdings) => Padding(
            padding: const EdgeInsets.only(top: 8),
            child: LineItem(
                title: 'Cash available',
                value: holdings?.dollarsOf(Currencies.dollars).toString()),
          ));

  Widget _transactionCards() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [DepositCard(), SpendCard()]);
}

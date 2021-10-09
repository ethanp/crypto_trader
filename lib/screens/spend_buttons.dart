import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';

class SpendButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(children: [
        _cashAvailable(),
        _deposit(),
        _spend(),
      ]),
    );
  }

  Widget _cashAvailable() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: WithHoldings(builder: (holdings) {
        final dollars = holdings?.dollarsOf(Currencies.dollars).toString();
        return Text(
          'Cash available: ' + (dollars ?? 'Loading'),
          style: kCashAvailableStyle,
        );
      }),
    );
  }

  TransferRow _deposit() {
    return TransferRow(
      action: Environment.trader.deposit,
      buttonText: (holdings) => 'Deposit Dollars',
      initialInput: (holdings) => Dollars(50),
    );
  }

  TransferRow _spend() {
    return TransferRow(
      action: Environment.trader.spend,
      buttonText: (holdings) => 'Buy ${holdings.shortest.currency.name}',
      initialInput: (holdings) => holdings.dollarsOf(Currencies.dollars),
    );
  }

  static final kCashAvailableStyle = TextStyle(fontSize: 20);
}

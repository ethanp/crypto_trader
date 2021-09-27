import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';

class SpendButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, bottom: 60),
      child: Column(children: [
        _cashAvailable(Theme.of(context)),
        _deposit(),
        _spend(),
      ]),
    );
  }

  Widget _cashAvailable(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: WithHoldings(builder: (holdings) {
        final dollars = holdings?.dollarsOf(Currencies.dollars).toString();
        return Text(
          'Cash available: ' + (dollars ?? 'Loading'),
          style: theme.textTheme.headline6,
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
}

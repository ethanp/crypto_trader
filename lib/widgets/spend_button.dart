import 'package:crypto_trader/data/data_sources.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:crypto_trader/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpendButton extends StatelessWidget {
  final _amount = Dollars(0.01);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Trader.api.spend(_amount);
        context.read<Notifier>().triggerUiRebuild();
      },
      child: FutureBuilder<Holdings>(
          future: Trader.api.getMyHoldings(),
          builder: (context, snapshot) {
            final currencyToBuy = snapshot.data?.biggestShortfall.currency.name;
            return Text('Spend $_amount on ${currencyToBuy ?? '(Loading...)'}');
          }),
    );
  }
}

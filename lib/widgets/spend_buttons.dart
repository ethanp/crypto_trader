import 'package:crypto_trader/data/data_sources.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:crypto_trader/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpendButtons extends StatelessWidget {
  final _amount = Dollars(0.01);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [_depositButton(context), _spendButton(context)],
    );
  }

  Widget _depositButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.green),
      onPressed: () {
        Trader.api.deposit(_amount);
        context.read<Notifier>().triggerUiRebuild();
      },
      child: _text(context, 'Deposit $_amount from Schwab'),
    );
  }

  Widget _spendButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Trader.api.spend(_amount);
        context.read<Notifier>().triggerUiRebuild();
      },
      child: FutureBuilder<Holdings>(
        future: Trader.api.getMyHoldings(),
        builder: (ctx, snapshot) {
          final currency = snapshot.data?.shortest.currency.name;
          return _text(ctx, 'Spend $_amount on ${currency ?? '(Loading...)'}');
        },
      ),
    );
  }

  Widget _text(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(text, style: Theme.of(context).textTheme.button),
    );
  }
}

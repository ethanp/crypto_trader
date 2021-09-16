import 'package:crypto_trader/data/data_sources.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:crypto_trader/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpendButtons extends StatelessWidget {
  // TODO allow user to modify this
  final _amount = Dollars(60);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      // TODO it reloads the info after spend but not after deposit.
      //  What's the difference between the two implementation-wise?
      children: [_depositButton(context), _spendButton(context)],
    );
  }

  Widget _depositButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.green),
      onPressed: () {
        Environment.trader
            .deposit(_amount)
            .whenComplete(() => context.read<UiRefresher>().refreshUi());
      },
      child: _text(context, 'Deposit $_amount from Schwab'),
    );
  }

  Widget _spendButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: () {
          Environment.trader
              // TODO: Consider using the full cash balance instead of set
              //  amount, or both.
              .spend(_amount)
              .whenComplete(() => context.read<UiRefresher>().refreshUi());
        },
        child: FutureBuilder<Holdings>(
          future: Environment.trader.getMyHoldings(),
          builder: (ctx, snapshot) {
            final currency = snapshot.data?.shortest.currency
                .holding(dollarValue: _amount)
                .asPurchaseStr;
            return _text(ctx, 'Buy ${currency ?? '(Loading...)'}');
          },
        ),
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

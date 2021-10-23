import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/util.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Area of the screen with the cash available, deposit, and spend Widgets.
class TransactButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final executor = context.watch<MultistageCommandExecutor>();
    return Container(
        color: Colors.grey[800],
        child: Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 2),
            child: Column(children: [
              _cashAvailable(),
              // TODO janky switch due to different sizes.
              // TODO this switcher should wrap the whole column so that
              //  during a txn, instead of _cashAvailable() it shows
              //  eg. "Depositing $20.23" or "Buying $10 of Bitcoin" etc.
              //  instead of showing the snackbar at the beginning of the txn.
              AnimatedSwitcher(
                  duration: const Duration(seconds: 1),
                  child: executor.isRunning
                      ? _actionProgress(executor)
                      : _transactionCards()),
            ])));
  }

  Widget _cashAvailable() => WithHoldings(
      builder: (holdings) => LineItem(
          title: 'Cash available',
          value: holdings?.dollarsOf(Currencies.dollars).toString()));

  String _stageName(MultistageCommandState state) {
    switch (state) {
      case MultistageCommandState.scheduled:
        return 'Scheduled';
      case MultistageCommandState.requesting:
        return 'Requesting';
      case MultistageCommandState.verifying:
        return 'Verifying';
      case MultistageCommandState.success:
        return 'Completed successfully';
      case MultistageCommandState.errorDuringRequest:
        return 'Aborted: something went wrong during request';
      case MultistageCommandState.errorDuringVerify:
        return 'Aborted: something went wrong during verify';

      default:
        throw Exception('Insufficient switch case: $state');
    }
  }

  Widget _actionProgress(MultistageCommandExecutor executor) {
    // TODO easy but not great change: Wrap this in a card that takes up
    //  space matching the two cards that were taken away.
    // TODO better difficult change: show an animation here that demonstrates
    //  what's going on.
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Text(_stageName(executor.state)));
  }

  Widget _transactionCards() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [DepositCard(), SpendCard()]);
}

import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
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
              if (executor.isRunning)
                _actionProgress(executor)
              else
                _transactionCards()
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
        return 'Requesting';
      case MultistageCommandState.success:
        return 'Completed without any errors';
      case MultistageCommandState.errorDuringRequest:
        return 'Aborted due to error, s';
      case MultistageCommandState.errorDuringVerify:
        return 'Aborted due to error, s';

      default:
        throw Exception('Insufficient switch case: $state');
    }
  }

  Widget _actionProgress(MultistageCommandExecutor executor) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Text(_stageName(executor.state)));
  }

  Widget _transactionCards() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [DepositCard(), SpendCard()]);
}

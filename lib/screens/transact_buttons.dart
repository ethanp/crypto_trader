import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Area of the screen with the cash available, deposit, and spend Widgets.
class TransactButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final executor = context.watch<MultistageActionExecutor>();
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

  String _stageName(MultistageActionState state) {
    switch (state) {
      case MultistageActionState.scheduled:
        return 'Scheduled';
      case MultistageActionState.requesting:
        return 'Requesting';
      case MultistageActionState.verifying:
        return 'Requesting';
      case MultistageActionState.success:
        return 'Completed without any errors';
      case MultistageActionState.errorDuringRequest:
        return 'Aborted due to error, s';
      case MultistageActionState.errorDuringVerify:
        return 'Aborted due to error, s';

      default:
        throw Exception('Insufficient switch case: $state');
    }
  }

  Widget _actionProgress(MultistageActionExecutor executor) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Text(_stageName(executor.state)));
  }

  Widget _transactionCards() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [DepositCard(), SpendCard()]);
}

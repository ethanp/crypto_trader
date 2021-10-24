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
        height: MediaQuery.of(context).size.height / 4.4,
        width: MediaQuery.of(context).size.width,
        child: Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 2),
            child: AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: Column(children: [
                  _title(executor),
                  if (executor.isRunning)
                    _actionProgress(executor)
                  else
                    _transactionCards(),
                ]))));
  }

  Widget _title(MultistageCommandExecutor executor) =>
      executor.isRunning ? _txnTitle(executor) : _cashAvailable();

  Widget _txnTitle(MultistageCommandExecutor executor) {
    final commandType = executor.currCommand?.runtimeType;
    final text = commandType == DepositCommand ? 'Depositing' : 'Buying crypto';
    final transactCommand = executor.currCommand! as TransactCommand;
    return LineItem(title: text, value: transactCommand.amount.toString());
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
        return 'Issuing transaction request';
      case MultistageCommandState.verifying:
        return 'Verifying transaction';
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

  Widget _actionProgress(MultistageCommandExecutor executor) => Padding(
      padding: const EdgeInsets.all(30),
      child: Text(
        _stageName(executor.state),
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 30),
      ));

  Widget _transactionCards() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [DepositCard(), SpendCard()]);
}

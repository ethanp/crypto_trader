import 'package:crypto_trader/import_facade/util.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';

class WhileRunning extends StatelessWidget {
  const WhileRunning(this.executor);

  final MultistageCommandExecutor executor;

  @override
  Widget build(BuildContext context) =>
      Column(children: [_txnTitle(), _actionProgress()]);

  Widget _txnTitle() {
    final commandType = executor.currCommand?.runtimeType;
    final text = commandType == DepositCommand ? 'Depositing' : 'Buying crypto';
    final transactCommand = executor.currCommand! as TransactCommand;
    return Padding(
        padding: const EdgeInsets.only(top: 30),
        child: LineItem(
            title: text,
            value: transactCommand.amount.toString(),
            bigger: true));
  }

  Widget _actionProgress() => Padding(
      padding: const EdgeInsets.all(15),
      child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 800),
          switchInCurve: Curves.easeInToLinear,
          switchOutCurve: Curves.easeInToLinear,
          child: Text(_stageName(),
              key: ValueKey(_stageName()),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontStyle: FontStyle.italic,
              ))));

  String _stageName() {
    switch (executor.state) {
      case MultistageCommandState.scheduled:
        return 'Scheduled';
      case MultistageCommandState.requesting:
        return 'Issuing transaction request';
      case MultistageCommandState.verifying:
        return 'Verifying transaction...';
      case MultistageCommandState.success:
        return 'Completed successfully';
      case MultistageCommandState.errorDuringRequest:
        return 'Aborted: something went wrong during request';
      case MultistageCommandState.errorDuringVerify:
        return 'Aborted: something went wrong during verify';

      default:
        throw Exception('Insufficient switch case: ${executor.state}');
    }
  }
}

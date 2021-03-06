import 'package:crypto_trader/import_facade/ui.dart';
import 'package:crypto_trader/import_facade/util.dart';
import 'package:flutter/material.dart';

class WhileRunning extends StatelessWidget {
  const WhileRunning(this.executor);

  final MultistageCommandExecutor executor;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 2),
        child: Column(children: [_txnTitle(), _actionProgress()]),
      );

  Widget _txnTitle() {
    final transactCommand = executor.currCommand! as TransactCommand;
    return LineItem(
        title: transactCommand.title,
        value: transactCommand.subtitle,
        row: true,
        bigger: true);
  }

  Widget _actionProgress() => AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      switchInCurve: Curves.easeInToLinear,
      switchOutCurve: Curves.easeInToLinear,
      child: Text(_stageName(),
          key: ValueKey(_stageName()),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, fontStyle: FontStyle.italic)));

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

import 'package:crypto_trader/import_facade/util.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Area of the screen with the cash available, deposit, and spend Widgets;
/// and while a transaction is taking place, display its progress.
class TransactionArea extends StatelessWidget {
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
                duration: const Duration(milliseconds: 800),
                switchInCurve: Curves.easeInToLinear,
                switchOutCurve: Curves.easeInToLinear,
                child: executor.isRunning
                    ? WhileRunning(executor)
                    : executor.hasError
                        ? _showError(executor)
                        : TransactButtons())));
  }

  Widget _showError(MultistageCommandExecutor executor) {
    Future.delayed(const Duration(seconds: 4), () => executor.resetError());
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(flex: 3),
        MyText(
          'Error',
          fontSize: 35,
          color: Colors.red[300],
        ),
        const Spacer(),
        MyText(
          executor.currCommand!.error.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            color: Colors.red[100],
            fontStyle: FontStyle.italic,
          ),
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}

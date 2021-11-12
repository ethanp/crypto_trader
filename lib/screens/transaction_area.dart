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
                child: _currentUi(executor))));
  }

  Widget _currentUi(MultistageCommandExecutor executor) {
    if (executor.isRunning) {
      return WhileRunning(executor);
    } else if (executor.hasError) {
      return ShowError(executor);
    } else {
      return TransactButtons();
    }
  }
}

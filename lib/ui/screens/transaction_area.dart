import 'package:crypto_trader/import_facade/ui.dart';
import 'package:crypto_trader/import_facade/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Area of the screen with the cash available, deposit, and spend Widgets;
/// and while a transaction is taking place, display its progress.
class TransactionArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 2),
      child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 800),
          switchInCurve: Curves.easeInToLinear,
          switchOutCurve: Curves.easeInToLinear,
          child: _currentUi(context.watch<MultistageCommandExecutor>())));

  Widget _currentUi(MultistageCommandExecutor executor) {
    if (executor.state.isRunning)
      return WhileRunning(executor);
    else if (executor.state.hasError)
      return ShowError(executor);
    else
      return BuySection();
  }
}

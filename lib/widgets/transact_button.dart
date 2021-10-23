import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/ui_refresher.dart';
import 'package:crypto_trader/import_facade/util.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// UI [Button] that triggers a financial transaction.
class TransactButton extends StatelessWidget {
  /// UI [Button] that triggers a financial transaction.
  const TransactButton(this.action, this.color, this.amount);

  /// What happens when you click the button.
  final Future<String> Function(Dollars) action;

  final Color color;

  final ValueNotifier<String> amount;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 35,
        child: FloatingActionButton(
          elevation: 4,
          onPressed: () => _transact(context),
          backgroundColor: color,
          child: const Icon(Icons.play_arrow_rounded),
        ),
      );

  Future<void> _transact(BuildContext context) async {
    // Get the NEWEST version of the input text.
    final userAmt = amount.value;
    if (AmountField.validateAmount(userAmt) != null)
      // Early return
      // TODO we should disable the button when the amount is invalid, which
      //  would make this happily-inaccessible code.
      return MySnackbar(
          context, 'Invalid amount \$$userAmt', const Duration(seconds: 3));
    MySnackbar(context, 'Transacting $userAmt', const Duration(seconds: 2));
    try {
      final executor = context.read<MultistageActionExecutor>();
      final cmd = TransactAction(Dollars(double.parse(userAmt)), action);
      await executor.add(cmd);
    } catch (err) {
      MySnackbar(context, err.toString(), const Duration(seconds: 20));
    } finally {
      // TODO Remove this, context.watch<Executor> should be sufficient if
      //  placed in the right build() impls.
      UiRefresher.refresh(context);
    }
  }
}

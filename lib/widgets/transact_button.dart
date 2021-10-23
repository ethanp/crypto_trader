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
      return _inputSnackbar(context, userAmt);
    MySnackbar.simple(
      text: 'Transacting $userAmt',
      duration: const Duration(seconds: 2),
      context: context,
    );
    try {
      final executor = context.read<MultistageActionExecutor>();
      final cmd = TransactAction(Dollars(double.parse(userAmt)), action);
      await executor.add(cmd);
    } catch (err) {
      _showError(context, err);
    } finally {
      // TODO Remove this, context.watch<Executor> should be sufficient if
      //  placed in the right build() impls.
      UiRefresher.refresh(context);
    }
  }

  void _inputSnackbar(BuildContext context, String amount) => MySnackbar.simple(
        context: context,
        text: 'Invalid amount \$$amount',
        duration: const Duration(seconds: 3),
      );

  // TODO change the color: make it redder too.
  void _showError(BuildContext context, Object err) => MySnackbar.simple(
        context: context,
        text: err.toString(),
        duration: const Duration(minutes: 1),
      );
}

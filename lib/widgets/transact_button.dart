import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/util.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// UI [Button] that triggers a financial transaction.
class TransactButton extends StatelessWidget {
  /// UI [Button] that -- on press -- triggers a financial transaction.
  const TransactButton(this.createCommand, this.amountListenable);

  /// Build the [MultistageCommand] that executes when you click the button.
  final MultistageCommand Function(Dollars) createCommand;

  final ValueNotifier<String> amountListenable;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 35,
        child: ValueListenableBuilder<String>(
          valueListenable: amountListenable,
          builder: (context, value, child) {
            final buttonEnabled = AmountField.validateAmount(value) == null;
            return FloatingActionButton(
              elevation: 7,
              onPressed: buttonEnabled ? () => _transact(context) : null,
              backgroundColor:
                  buttonEnabled ? Colors.lightBlueAccent : Colors.grey,
              child: const Icon(Icons.attach_money),
            );
          },
        ),
      );

  Future<void> _transact(BuildContext context) async {
    try {
      final executor = context.read<MultistageCommandExecutor>();
      // Get the NEWEST version of the input text.
      final cmd = createCommand(Dollars(double.parse(amountListenable.value)));
      // By the time the `add` returns the command has queued.
      // By the time `await` returns the command has executed.
      await executor.add(cmd);
    } catch (err) {
      MySnackbar(context, err.toString(), const Duration(seconds: 20));
    }
  }
}

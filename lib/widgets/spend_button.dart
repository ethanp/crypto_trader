import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/ui_refresher.dart';
import 'package:crypto_trader/import_facade/util.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// UI [Button] that triggers a financial transaction.
class SpendButton extends StatelessWidget {
  /// UI [Button] that triggers a financial transaction.
  const SpendButton(this.action, this.buttonText, this.input, this.holdings);

  /// What happens when you click the button.
  final Future<String> Function(Dollars) action;

  /// What the button says on it.
  final String Function(Holdings) buttonText;

  /// Reference to the controller for the relevant field.
  final TextEditingController input;

  /// Reference to global [Holdings] that will be null while loading, and then
  /// filled with a valid reference once the Holdings have been retrieved from
  /// the CoinbasePro API.
  final Holdings? holdings;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _transact(context),
      child: holdings == null
          ? const CupertinoActivityIndicator()
          : MyText(
              buttonText(holdings!),
              style: TextStyle(
                color: Colors.grey[100],
                fontSize: 20,
                fontWeight: FontWeight.w400,
                letterSpacing: -1.5,
              ),
            ),
    );
  }

  void _transact(BuildContext context) {
    // Get the NEWEST version of the input text.
    final amount = input.text;
    if (!_inputIsValid(amount)) return _inputSnackbar(context, amount);
    MySnackbar.simple(
      text: 'Transacting $amount',
      duration: const Duration(seconds: 2),
      context: context,
    );
    _triggerAction(amount)
        // There must be some way to clean this up.
        .then((_) {}, onError: (Object err) => _showError(context, err))
        .then((_) => _eventuallyRefresh(context));
  }

  Future<String> _triggerAction(String amount) =>
      action(Dollars(double.parse(amount)));

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

  Future<void> _eventuallyRefresh(BuildContext context) {
    MySnackbar.simple(
      context: context,
      text: 'Waiting for Coinbase to update',
      duration: const Duration(seconds: 3),
    );
    print('Scheduling refresh');
    // We need this delay because the transfer from Schwab takes a
    // few seconds to be reflected. 4 wasn't enough so using 8.
    return Future.delayed(
        const Duration(seconds: 8), () => UiRefresher.refresh(context));
  }

  static bool _inputIsValid(String? input) =>
      AmountField.validateAmount(input) == null;
}

import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/ui_refresher.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';

class SpendButton extends StatelessWidget {
  final Future<String> Function(Dollars) action;
  final String Function(Holdings) buttonText;
  final TextEditingController input;
  final Holdings? holdings;

  const SpendButton(this.action, this.buttonText, this.input, this.holdings);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Get the NEWEST version of the input text.
        final amount = input.text;
        if (!_inputIsValid(amount)) return _inputSnackbar(context, amount);
        _snackbar(context, 'Transacting $amount', Duration(seconds: 2));
        _transact(amount)
            // Func is required for type-bug in the Future API :/
            .then((_) {}, onError: (Object err) => _showError(context, err))
            .then((value) => _eventuallyRefresh(context));
      },
      child: Text(holdings == null ? 'Loading' : buttonText(holdings!)),
    );
  }

  Future<String> _transact(String amount) =>
      action(Dollars(double.parse(amount)));

  void _inputSnackbar(BuildContext context, String amount) =>
      _snackbar(context, 'Invalid amount \$$amount', Duration(seconds: 3));

  void _showError(BuildContext context, Object err) =>
      _snackbar(context, err.toString(), Duration(minutes: 1));

  Future<void> _eventuallyRefresh(BuildContext context) {
    _snackbar(context, 'Waiting for Coinbase', Duration(seconds: 6));
    print('Scheduling refresh');
    // We need this delay because the transfer from Schwab takes a
    // few seconds to be reflected. 4 wasn't enough so using 8.
    return Future.delayed(
        Duration(seconds: 8), () => UiRefresher.refresh(context));
  }

  void _snackbar(BuildContext context, String text, Duration duration) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWithCountdown(text, initialCount: duration.inSeconds),
        duration: duration,
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {},
          textColor: Colors.blueGrey[200],
        ),
      ));

  static bool _inputIsValid(String? input) =>
      AmountField.validateInput(input) == null;
}

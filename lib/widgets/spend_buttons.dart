import 'dart:async';

import 'package:crypto_trader/data/data_sources.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:crypto_trader/helpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SpendButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TransferRow(
          transact: Environment.trader.deposit,
          buttonText: (holdings) => 'Deposit Dollars',
          initialInput: (holdings) => Dollars(50),
        ),
        TransferRow(
          transact: Environment.trader.spend,
          buttonText: (holdings) => 'Buy ${holdings.shortest.currency.name}',
          initialInput: (holdings) => holdings.of(dollars),
        )
      ],
    );
  }
}

class TransferRow extends StatelessWidget {
  final Future<String> Function(Dollars) transact;
  final String Function(Holdings) buttonText;
  final Dollars Function(Holdings) initialInput;

  const TransferRow({
    required this.transact,
    required this.buttonText,
    required this.initialInput,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Holdings>(
      future: Environment.trader.getMyHoldings(),
      builder: (ctx, snapshot) {
        if (snapshot.data == null) return Text('Loading');
        final Holdings holdings = snapshot.data!;
        final fieldController = TextEditingController(
          text: NumberFormat('##0.##').format(initialInput(holdings).rounded),
        );
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              _field(fieldController),
              SizedBox(width: 15),
              _button(fieldController, ctx, holdings),
            ],
          ),
        );
      },
    );
  }

  OutlinedButton _button(
    TextEditingController input,
    BuildContext context,
    Holdings holdings,
  ) {
    return OutlinedButton(
      onPressed: () {
        // Get the NEWEST version of the input text.
        final amount = input.text;
        if (!_inputIsValid(amount)) return _inputSnackbar(context, amount);
        _transact(amount)
            // Func is required for type-bug in the Future API :/
            .then((_) {}, onError: (Object err) => _showError(context, err))
            .then((value) => _eventuallyRefresh(context));
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(buttonText(holdings)),
      ),
    );
  }

  Future<String> _transact(String amount) =>
      transact(Dollars(double.parse(amount)));

  void _inputSnackbar(BuildContext context, String amount) =>
      _snackbar(context, 'Invalid amount \$$amount', Duration(seconds: 3));

  void _showError(BuildContext context, Object err) =>
      _snackbar(context, err.toString(), Duration(minutes: 1));

  Future<void> _eventuallyRefresh(BuildContext context) {
    _snackbar(context, 'Waiting for Coinbase', Duration(seconds: 8));
    print('Scheduling refresh');
    // We need this delay because the transfer from Schwab takes a
    // few seconds to be reflected. 4 wasn't enough so using 8.
    return Future.delayed(
        Duration(seconds: 8), () => context.read<UiRefresher>().refreshUi());
  }

  void _snackbar(BuildContext context, String text, Duration duration) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(text), duration: duration));

  SizedBox _field(TextEditingController fieldController) {
    return SizedBox(
      width: 80,
      child: TextFormField(
        controller: fieldController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: '\$ Amount',
        ),
        textAlign: TextAlign.center,
        validator: _validateInput,
        autovalidateMode: AutovalidateMode.always,
      ),
    );
  }

  bool _inputIsValid(String? input) => _validateInput(input) == null;

  String? _validateInput(String? input) {
    if (input == null || input.isEmpty)
      return 'Empty';
    else if (double.tryParse(input) == null)
      return 'Not \$';
    else if (double.parse(input) < 10)
      return 'Too small';
    else if (double.parse(input) >= 100)
      return 'Too big';
    else if (input.indexOf('.') < input.length - 3)
      return 'Not \$';
    else
      return null;
  }
}

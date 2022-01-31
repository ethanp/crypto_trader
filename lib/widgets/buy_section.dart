import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/util.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

/// 1. Deposit until dollars = user input
/// 2. Buy user-input amount of the currently-selected currency.
class BuySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final commandExecutor = context.read<MultistageCommandExecutor>();
    final textEditingController = TextEditingController();
    final selectedCurrency = context.watch<PortfolioState>().currency;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Row(children: [
        _textFormField(textEditingController, selectedCurrency),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () => _buyButtonHandler(
            commandExecutor,
            textEditingController,
            selectedCurrency,
          ),
          child: const Text('Buy'),
        ),
      ]),
    );
  }

  Widget _textFormField(
    TextEditingController textEditingController,
    Currency selectedCurrency,
  ) {
    return SizedBox(
      width: 100,
      child: TextFormField(
        controller: textEditingController,
        textAlign: TextAlign.right,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        autovalidateMode: AutovalidateMode.always,
        validator: _userInputValidator,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[\.0-9]')),
          LengthLimitingTextInputFormatter(5),
        ],
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          errorStyle: TextStyle(color: Colors.red[500]),
          fillColor: Colors.grey[800]!.withOpacity(0.7),
          filled: true,
          labelText: '\$ $selectedCurrency',
          labelStyle: TextStyle(color: Colors.green[200]),
          isDense: true,
          contentPadding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
        ),
      ),
    );
  }

  Future<void> _buyButtonHandler(
    MultistageCommandExecutor commandExecutor,
    TextEditingController textEditingController,
    Currency selectedCurrency,
  ) async {
    final validation = _userInputValidator(textEditingController.text);
    if (validation != null) {
      print('Invalid userInput ${textEditingController.text}: $validation');
      return;
    }
    final userInput = double.tryParse(textEditingController.text);
    if (userInput == null || userInput < 10 || userInput > 100) {
      // The validation above should have checked for all these possibilities.
      print('ERROR, we should not get here: ${textEditingController.text}');
      return;
    }
    final dollarsToSpend = Dollars(userInput);
    final holdings = await Environment.trader.getMyHoldings();
    final dollarsToDeposit = dollarsToSpend - holdings.of(Currencies.dollars);
    if (dollarsToDeposit.amt > 0) {
      if (dollarsToDeposit.amt < 10) dollarsToDeposit.amt = 10;
      // IIUC, awaiting this will cause us to wait till the deposit
      // completes.
      await commandExecutor.enqueue(DepositCommand(dollarsToDeposit));
    }
    await commandExecutor.enqueue(PurchaseCommand(Holding(
      currency: selectedCurrency,
      dollarValue: dollarsToSpend,
    )));
  }

  String? _userInputValidator(String? curr) {
    if (curr == null) return null;
    curr = curr.trim();
    if (curr.isEmpty) return null;
    final parsedDouble = double.tryParse(curr);
    if (parsedDouble == null) return 'Number';
    if (parsedDouble < 10) return '>10';
    if (parsedDouble > 100) return '≤\$100';
    return null;
  }
}

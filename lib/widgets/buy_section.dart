import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 1. Deposit until dollars = user input
/// 2. Buy user-input amount of the currently-selected currency.
class BuySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final executor = context.read<MultistageCommandExecutor>();
    final textEditingController = TextEditingController();
    final selectedCurrency = Currencies.dollars; // TODO read from context.

    final userInputAmountField = SizedBox(
      width: 50,
      child: TextFormField(
        controller: textEditingController,
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Row(children: [
        userInputAmountField,
        const SizedBox(width: 20),
        _buyButton(executor, textEditingController, selectedCurrency),
      ]),
    );
  }

  ElevatedButton _buyButton(
    MultistageCommandExecutor executor,
    TextEditingController textEditingController,
    Currency selectedCurrency,
  ) {
    return ElevatedButton(
      onPressed: () => _buyButtonHandler(
        executor,
        textEditingController,
        selectedCurrency,
      ),
      child: const Text('Buy'),
    );
  }

  Future<void> _buyButtonHandler(
    MultistageCommandExecutor executor,
    TextEditingController textEditingController,
    Currency selectedCurrency,
  ) async {
    final userInput = double.tryParse(textEditingController.text);
    if (userInput == null) {
      print('Invalid userInput ${textEditingController.text}');
      return;
    }
    final dollarsToSpend = Dollars(userInput);
    final holdings = await Environment.trader.getMyHoldings();
    final dollarsToDeposit = dollarsToSpend - holdings.of(Currencies.dollars);
    // IIUC, awaiting this will cause us to wait till the deposit
    // completes.
    await executor.enqueue(DepositCommand(dollarsToDeposit));
    await executor.enqueue(PurchaseCommand(Holding(
      currency: selectedCurrency,
      dollarValue: dollarsToSpend,
    )));
  }
}

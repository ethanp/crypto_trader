import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/util.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';
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
        SizedBox(
          width: 50,
          child: TextFormField(
            controller: textEditingController,
          ),
        ),
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

  Future<void> _buyButtonHandler(
    MultistageCommandExecutor commandExecutor,
    TextEditingController textEditingController,
    Currency selectedCurrency,
  ) async {
    // TODO check that it's a valid number > 10.
    final userInput = double.tryParse(textEditingController.text);
    if (userInput == null) {
      print('Invalid userInput ${textEditingController.text}');
      return;
    }
    final dollarsToSpend = Dollars(userInput);
    final holdings = await Environment.trader.getMyHoldings();
    final dollarsToDeposit = dollarsToSpend - holdings.of(Currencies.dollars);
    if (dollarsToDeposit.amt > 1) {
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
}

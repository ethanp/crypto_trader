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
    // Lint said not to read context within async callback so moved this here.
    final executor = context.read<MultistageCommandExecutor>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Row(children: [
        SizedBox(width: 50, child: TextFormField()),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () async {
            final userInput = Dollars(5);
            final holdings = await Environment.trader.getMyHoldings();
            final dollars = holdings.dollarsOf(Currencies.dollars);
            final remaining = userInput - dollars;
            // IIUC, awaiting this will cause us to wait till the deposit
            // completes.
            await executor.add(DepositCommand(remaining));
            await executor.add(SpendCommand(userInput));
          },
          child: const Text('Buy'),
        ),
      ]),
    );
  }
}

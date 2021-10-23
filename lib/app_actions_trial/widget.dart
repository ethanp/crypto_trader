import 'package:crypto_trader/commands/command.dart';
import 'package:crypto_trader/commands/executor.dart';
import 'package:crypto_trader/commands/test.dart';
import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/util.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppActionsTrialTopLevel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MultistageCommandExecutor())
      ],
      builder: (context, _) {
        final executor = context.watch<MultistageCommandExecutor>();
        const size = 15.0;
        const font = TextStyle(fontSize: size);
        final text = executor.currCommand?.state ?? 'No action';
        return MaterialApp(
          title: 'App actions trial',
          home: Scaffold(
            body: Center(
              child: WithHoldings(
                builder: (holdings) {
                  final shortestCurrency = holdings?.shortest.currency.name;
                  final currencyName = shortestCurrency ?? 'Loading';
                  final amount = Dollars(10); // Smallest amount allowed.
                  final buyText = 'Buy $amount of $currencyName';
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('State: $text', style: font),
                      ActionButton(executor, 'No error', FakeCommand()),
                      ActionButton(
                          executor, 'Error on request', ErrantRequestCommand()),
                      ActionButton(
                          executor, 'Error on verify', ErrantVerifyCommand()),
                      ActionButton(executor, 'Deposit $amount',
                          TransactCommand(amount, Environment.trader.deposit)),
                      ActionButton(executor, buyText,
                          TransactCommand(amount, Environment.trader.spend)),
                    ]
                        .expand(
                            (element) => [const SizedBox(height: 10), element])
                        .toList(),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton(this.executor, this.text, this.command);

  final MultistageCommandExecutor executor;
  final String text;
  final MultistageCommand command;

  @override
  Widget build(BuildContext context) => ElevatedButton(
      style: ElevatedButton.styleFrom(elevation: 10),
      onPressed: () => _onPressed(executor, command),
      child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(text, style: const TextStyle(fontSize: 20))));

  Future<void> _onPressed(
    MultistageCommandExecutor executor,
    MultistageCommand action,
  ) async {
    print('Button pressed');
    // Docs for this: https://dart.dev/codelabs/async-await#handling-errors
    try {
      await executor.add(action);
    } on Exception catch (e) {
      print('Caught exception $e');
    }
  }
}

import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppActionsTrialTopLevel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MultistageActionExecutor())
      ],
      builder: (context, _) {
        final executor = context.watch<MultistageActionExecutor>();
        const size = 15.0;
        const font = TextStyle(fontSize: size);
        final text = executor.currAction?.state ?? 'No action';
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
                      ActionButton(executor, 'No error', FakeAction()),
                      ActionButton(
                          executor, 'Error on request', ErrantRequestAction()),
                      ActionButton(
                          executor, 'Error on verify', ErrantVerifyAction()),
                      ActionButton(
                          executor, 'Deposit $amount', DepositAction(amount)),
                      ActionButton(executor, buyText, SpendAction(amount)),
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
  const ActionButton(this.executor, this.text, this.action);

  final MultistageActionExecutor executor;
  final String text;
  final MultistageAction action;

  @override
  Widget build(BuildContext context) => ElevatedButton(
      style: ElevatedButton.styleFrom(elevation: 10),
      onPressed: () => _onPressed(executor, action),
      child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(text, style: const TextStyle(fontSize: 20))));

  Future<void> _onPressed(
    MultistageActionExecutor executor,
    MultistageAction action,
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

import 'package:crypto_trader/data/controller/app_actions.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(AppActionsTrialTopLevel());

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('State: $text', style: font),
                  _actionButton(executor, 'No error', FakeAction()),
                  _actionButton(
                      executor, 'Error on request', ErrantRequestAction()),
                  _actionButton(
                      executor, 'Error on verify', ErrantVerifyAction()),
                  _actionButton(
                      executor, 'Deposit \$10', DepositAction(Dollars(10))),
                ]
                    .expand((element) => [const SizedBox(height: 10), element])
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _actionButton(
    MultistageActionExecutor executor,
    String text,
    MultistageAction action,
  ) {
    const font = TextStyle(fontSize: 20);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(elevation: 10),
      onPressed: () => _onPressed(executor, action),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(text, style: font),
      ),
    );
  }

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

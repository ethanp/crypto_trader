import 'package:crypto_trader/data/controller/app_actions.dart';
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
        const size = 40.0;
        const font = TextStyle(fontSize: size);
        final text = executor.actions.isNotEmpty
            ? executor.actions.first.state.toString()
            : 'No action';
        return MaterialApp(
          title: 'App actions trial',
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('State: $text', style: font),
                  const SizedBox(height: size),
                  _actionButton(executor, font, FakeAction()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _actionButton(
    MultistageActionExecutor executor,
    TextStyle font,
    MultistageAction action,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(elevation: 10),
      onPressed: () => _onPressed(executor, action),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text('Start', style: font),
      ),
    );
  }

  void _onPressed(MultistageActionExecutor executor, MultistageAction action) {
    print('Button pressed');
    executor.add(action);
  }
}

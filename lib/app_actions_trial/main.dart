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
        context.watch<MultistageActionExecutor>();
        return MaterialApp(
          title: 'App actions trial',
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: _onPressed,
                    child: const Text('Start'),
                  ),
                  const SizedBox(height: 10),
                  const Text('State: Has not started'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onPressed() {
    print('Button pressed');
  }
}

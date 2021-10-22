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
        return MaterialApp(
          title: 'App actions trial',
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(elevation: 10),
                    onPressed: () => _onPressed(executor),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Start', style: font),
                    ),
                  ),
                  const SizedBox(height: size),
                  const Text('State: Has not started', style: font),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onPressed(MultistageActionExecutor executor) {
    print('Button pressed');
    executor.add(FakeAction());
  }
}

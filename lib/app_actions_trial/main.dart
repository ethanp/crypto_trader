import 'package:crypto_trader/import_facade/ui_refresher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() => runApp(AppActionsTrialTopLevel());

class AppActionsTrialTopLevel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UiRefresher())],
      child: MaterialApp(
        title: 'App actions trial',
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                    onPressed: _buttonPressed, child: const Text('Push me')),
                const SizedBox(height: 10),
                const Text('State: Has not started'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _buttonPressed() {
    print('Button pressed');
  }
}

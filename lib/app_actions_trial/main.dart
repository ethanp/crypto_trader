import 'package:flutter/material.dart';

void main() => runApp(AppActionsTrialTopLevel());

class AppActionsTrialTopLevel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App actions trial',
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(onPressed: _onPressed, child: const Text('Start')),
              const SizedBox(height: 10),
              const Text('State: Has not started'),
            ],
          ),
        ),
      ),
    );
  }

  void _onPressed() {
    print('Button pressed');
  }
}

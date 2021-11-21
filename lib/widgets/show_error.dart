import 'package:crypto_trader/import_facade/util.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';

class ShowError extends StatelessWidget {
  const ShowError(this.executor);

  final MultistageCommandExecutor executor;
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 4), () => executor.resetError());
    final error = executor.currCommand!.error;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(flex: 3),
        MyText(
          'Error',
          fontSize: 35,
          color: Colors.red[300],
        ),
        const Spacer(),
        MyText(
          error.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            color: Colors.red[100],
            fontStyle: FontStyle.italic,
          ),
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}

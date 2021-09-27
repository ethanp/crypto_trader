import 'package:crypto_trader/import_facade/ui_refresher.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UiRefresher.register(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Crypto: auto-balancing DCA'),
        leading: IconButton(
          onPressed: () => UiRefresher.refresh(context),
          tooltip: 'Refresh data',
          icon: Icon(Icons.refresh),
        ),
      ),
      body: Column(children: [
        TotalHoldings(),
        SpendButtons(),
        if (!_keyboardIsShowing(context)) Portfolio(),
      ]),
    );
  }

  bool _keyboardIsShowing(BuildContext context) =>
      MediaQuery.of(context).viewInsets.bottom != 0;
}

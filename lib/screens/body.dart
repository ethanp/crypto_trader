import 'package:crypto_trader/import_facade/ui_refresher.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';

/// Outermost [Scaffold] for the app.
class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UiRefresher.register(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const MyText('Crypto: auto-balancing DCA'),
        leading: _refreshButton(context),
      ),
      body: SafeArea(
        child: Column(children: [
          HoldingsFacts(),
          TransactButtons(),
          if (!_keyboardIsShowing(context)) Portfolio(),
        ]),
      ),
    );
  }

  Widget _refreshButton(BuildContext context) => IconButton(
        onPressed: () => UiRefresher.refresh(context),
        tooltip: 'Refresh data',
        icon: const Icon(Icons.refresh),
      );

  bool _keyboardIsShowing(BuildContext context) =>
      MediaQuery.of(context).viewInsets.bottom != 0;
}

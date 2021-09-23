import 'package:crypto_trader/helpers.dart';
import 'package:crypto_trader/screens/portfolio.dart';
import 'package:crypto_trader/screens/spend/spend_buttons.dart';
import 'package:crypto_trader/screens/total_holdings.dart';
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
        leading: InkWell(
          onTap: () => UiRefresher.refresh(context),
          child: Icon(Icons.refresh),
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

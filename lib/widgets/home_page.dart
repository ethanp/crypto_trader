import 'package:crypto_trader/helpers.dart';
import 'package:crypto_trader/widgets/portfolio.dart';
import 'package:flutter/material.dart';

import 'spend_buttons.dart';
import 'total_holdings.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UiRefresher.register(context);
    return Scaffold(
      appBar: AppBar(title: Text('Crypto: auto-balancing DCA')),
      body: Column(children: [
        TotalHoldings(),
        SpendButtons(),
        Flexible(child: Portfolio()),
      ]),
    );
  }
}

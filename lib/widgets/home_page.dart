import 'package:crypto_trader/helpers.dart';
import 'package:crypto_trader/widgets/portfolio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'spend/spend_buttons.dart';
import 'total_holdings.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UiRefresher.register(context);
    print('Rebuilding HomePage');
    return Scaffold(
      appBar: AppBar(
          title: Text('Crypto: auto-balancing DCA'),
          // TODO replace this with a real button or delete it. It doesn't have
          //  the InkWell effect so it's impossible to know when it's working.
          leading: GestureDetector(
            onTap: () => context.read<UiRefresher>().refreshUi(),
            child: Icon(Icons.refresh),
          )),
      body: Column(children: [
        TotalHoldings(),
        SpendButtons(),
        if (keyboardIsShowing(context)) Flexible(child: Portfolio()),
      ]),
    );
  }

  bool keyboardIsShowing(BuildContext context) =>
      MediaQuery.of(context).viewInsets.bottom == 0;
}

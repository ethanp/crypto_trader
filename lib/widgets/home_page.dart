import 'package:crypto_trader/data/data_sources.dart';
import 'package:crypto_trader/data_model.dart';
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
      appBar: AppBar(title: Text('Crypto: DCA with passive rebalancing')),
      body: Column(children: [
        TotalHoldings(),
        SpendButtons(),
        Flexible(child: Portfolio()),
      ]),
      floatingActionButton: _buyEthButton(),
    );
  }

  Widget _buyEthButton() {
    return FloatingActionButton(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.monetization_on_outlined),
          Text('Buy ETH', style: TextStyle(fontSize: 9)),
        ],
      ),
      onPressed: () => _buyEth(),
    );
  }

  void _buyEth() {
    print('Buying ETH...');
    CoinbaseProTrader().spendInternal(Holding(
      currency: ethereum,
      dollarValue: Dollars(2),
    ));
  }
}

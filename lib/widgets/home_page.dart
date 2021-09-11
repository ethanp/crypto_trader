import 'package:crypto_trader/data/data_sources.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:crypto_trader/widgets/portfolio.dart';
import 'package:flutter/material.dart';

import 'spend_buttons.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crypto: DCA with passive rebalancing')),
      body: Column(children: [
        Flexible(child: Portfolio()),
        SpendButtons(),
        SizedBox(height: 50),
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
    CoinbaseProTrader().buy(Holding(
      currency: ethereum,
      dollarValue: Dollars(25),
    ));
  }
}

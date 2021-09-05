import 'package:crypto_trader/data/data_sources.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:flutter/material.dart';

import 'bitcoin_price.dart';
import 'portfolio.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Invest in crypto')),
      body: Column(children: [
        BitcoinPrice(),
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
    CoinbaseProTrader().buy(Holding(
      currency: ethereum,
      dollarValue: Dollars(25),
    ));
  }
}

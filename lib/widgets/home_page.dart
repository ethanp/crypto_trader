import 'package:crypto_trader/data/data_sources.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:crypto_trader/widgets/portfolio.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crypto: DCA with passive rebalancing')),
      body: Column(
        children: [
          Flexible(child: Portfolio()),
          // TODO Implement: Trade dollars for cypto.
          Container(
            height: 100,
            color: Colors.blue[100],
            child: Text('TODO(implement): Trade dollars for crypto'),
          )
        ],
      ),
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

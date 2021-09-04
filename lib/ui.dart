import 'package:flutter/material.dart';

import 'data_model.dart';
import 'data_sources.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          headline3: TextStyle(
            color: Colors.green[700],
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Invest in crypto')),
      body: BitcoinPrice(),
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
    CoinbaseProTrader().buy(Holding(ethereum, Dollars(25)));
  }
}

class BitcoinPrice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            'Current Bitcoin price:',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        FutureBuilder<String>(
          future: CoinbaseProPrices().getCurrentPrice(of: bitcoin),
          builder: (BuildContext ctx, AsyncSnapshot<String> snapshot) => Text(
              snapshot.hasData ? snapshot.data! : 'Not connected or Loading...',
              style: Theme.of(context).textTheme.headline3),
        ),
      ],
    );
  }
}

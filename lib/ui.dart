import 'package:flutter/material.dart';

import 'data_model.dart';
import 'data_sources.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buyEthButton(),
          _refreshPricesButton(),
        ],
      ),
    );
  }

  Widget _refreshPricesButton() {
    return FloatingActionButton(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.refresh),
          Text('Refresh', style: TextStyle(fontSize: 9)),
        ],
      ),
      onPressed: () => _refreshPrices(),
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

  void _refreshPrices() async {
    print('Refreshing prices');
    print(await CoinbaseProPrices().getCurrentPrice(of: bitcoin));
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
        // TODO this should be FutureWidget.of(
        //   notYet: 'loading', loaded: latestPrice)
        Text(
          'Not connected',
          // TODO(UI): Make this the default style for headline3.
          style: Theme.of(context)
              .textTheme
              .headline3!
              .copyWith(color: Colors.green[900]),
        ),
      ],
    );
  }
}

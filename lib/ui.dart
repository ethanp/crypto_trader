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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Current Bitcoin price:',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Text(
            'Not connected',
            // TODO(UI): Make this the default style for headline3.
            style: Theme.of(context)
                .textTheme
                .headline3!
                .copyWith(color: Colors.green[900]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.monetization_on_outlined),
        onPressed: () => _buyEth(),
      ),
    );
  }

  void _buyEth() {
    print('Buying ETH...');
    CoinbaseProTrader().buy(Holding(ethereum, Dollars(25)));
  }
}

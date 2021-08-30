import 'package:flutter/material.dart';

void main() => runApp(MyApp());

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
      body: Center(
        child: Text(
          'Connection: Not connected',
          style: Theme.of(context).textTheme.headline5,
        ),
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

class Dollars {
  const Dollars(this.amt);

  final double amt;
}

class Holding {
  const Holding(this.cryptocurrency, this.dollars);

  final Cryptocurrency cryptocurrency;
  final Dollars dollars;
}

class Cryptocurrency {
  const Cryptocurrency({
    required this.name,
    required this.callLetters,
  });

  final String name;
  final String callLetters;
}

const bitcoin = Cryptocurrency(name: 'Bitcoin', callLetters: 'BTC');
const ethereum = Cryptocurrency(name: 'Ethereum', callLetters: 'ETH');
const cardano = Cryptocurrency(name: 'Cardano', callLetters: 'ADA');
const lightcoin = Cryptocurrency(name: 'Lightcoin', callLetters: 'LTC');
const bitcoinCash = Cryptocurrency(name: 'Bitcoin Cash', callLetters: 'BCH');

const portfolioCurrencies = [
  bitcoin,
  ethereum,
  cardano,
  lightcoin,
  bitcoinCash,
];

// Watch out for https://flutter.dev/desktop#setting-up-entitlements
abstract class Trader {
  void buy(Holding holding);
  List<Holding> getMyHoldings();
}

class CoinbaseProTrader implements Trader {
  final url = 'https://api.pro.coinbase.com';

  @override
  void buy(Holding holding) => throw UnimplementedError();
  @override
  List<Holding> getMyHoldings() => throw UnimplementedError();
}

abstract class Prices {}

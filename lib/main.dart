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
    Trader().buy(Holding('ETH', Dollars(25)));
  }
}

class Dollars {
  const Dollars(this.amt);

  final double amt;
}

class Holding {
  const Holding(this.code, this.dollars);

  final String code;
  final Dollars dollars;
}

// Watch out for https://flutter.dev/desktop#setting-up-entitlements
class Trader {
  void buy(Holding holding) {}
  List<Holding> getMyHoldings() => [];
}

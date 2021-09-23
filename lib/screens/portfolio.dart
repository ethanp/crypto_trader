import 'package:crypto_trader/data/data_sources.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Portfolio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Holdings>(
      future: Environment.trader.getMyHoldings(),
      builder: (ctx, holdings) => Flexible(
        child: Column(children: [
          Expanded(
              child: Stack(
            children: [
              Center(
                  child: Text(
                'Chart will go here',
                style: Theme.of(context).textTheme.headline5,
              )),
              Placeholder(color: Colors.black26),
            ],
          )),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: _cards(holdings.data),
          ),
        ]),
      ),
    );
  }

  Widget _cards(Holdings? holdings) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: portfolioCryptoCurrencies
            .map((currency) => MyCard(holdings, currency))
            .toList(),
      ),
    );
  }
}

class MyCard extends StatelessWidget {
  const MyCard(this.holdings, this.currency);

  final Holdings? holdings;
  final Currency currency;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      color: Colors.blue[100],
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(children: [
          _name(context),
          _holding(context),
          _percentageOfPortfolio(context),
        ]),
      ),
    );
  }

  Widget _percentageOfPortfolio(BuildContext context) {
    return holdings == null
        ? Text('Loading')
        : Row(children: [
            Text(
              '${holdings!.percentageContaining(currency).round()}%'
              ' / '
              '${currency.percentAllocation}%',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(width: 10),
            _difference(holdings!.difference(currency)),
          ]);
  }

  Text _holding(BuildContext context) {
    return Text(
      holdings?.dollarsOf(currency).toString() ?? 'Loading',
      style: Theme.of(context).textTheme.headline6,
    );
  }

  Widget _name(BuildContext context) {
    return Row(children: [
      Text(
        currency.callLetters,
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(color: Colors.grey[600]),
      ),
      SizedBox(width: 10),
      Text(
        currency.name,
        style: Theme.of(context).textTheme.headline5,
      ),
    ]);
  }

  Widget _difference(double difference) {
    final Color color = difference >= 0 ? Colors.red : Colors.green;
    return Text('${difference.round()}%', style: TextStyle(color: color));
  }
}

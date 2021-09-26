import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/widgets/portfolio_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Portfolio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Holdings>(
      future: Environment.trader.getMyHoldings(),
      builder: (ctx, holdings) => Flexible(
        child: Column(children: [
          Expanded(child: _chart(context)),
          _cards(holdings.data),
        ]),
      ),
    );
  }

  Widget _chart(BuildContext context) {
    return Stack(children: [
      Center(
          child: Text(
        'Chart will go here',
        style: Theme.of(context).textTheme.headline5,
      )),
      Placeholder(color: Colors.black26),
    ]);
  }

  Widget _cards(Holdings? holdings) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: Currencies.allCryptoCurrencies
              .map((currency) => PortfolioCard(holdings, currency))
              .toList(),
        ),
      ),
    );
  }
}

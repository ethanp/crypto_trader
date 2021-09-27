import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:crypto_trader/widgets/portfolio_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Portfolio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WithHoldings(
      builder: (holdings) => Expanded(
        child: Column(children: [
          _chart(context),
          _cards(holdings),
        ]),
      ),
    );
  }

  Widget _chart(BuildContext context) {
    return Expanded(
      child: Stack(children: [
        Center(
          child: Text(
            'Chart will go here',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        Placeholder(color: Colors.black26),
      ]),
    );
  }

  Widget _cards(Holdings? holdings) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40, top: 20),
        child: Row(
          children: Currencies.allCryptoCurrencies
              .map((currency) => PortfolioCard(holdings, currency))
              .toList(),
        ),
      ),
    );
  }
}

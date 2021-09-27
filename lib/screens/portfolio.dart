import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:crypto_trader/widgets/portfolio_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Portfolio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(children: [
        _chart(context),
        _cards(),
      ]),
    );
  }

  Widget _chart(BuildContext context) {
    return Expanded(
      child: Stack(children: [
        Center(
          child: Text(
            'Chart will go here',
            style: kChartPlaceholderStyle,
          ),
        ),
        Placeholder(color: Colors.black26),
      ]),
    );
  }

  Widget _cards() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40, top: 20),
        child: Row(
          children: Currencies.allCryptoCurrencies
              .map((c) => WithHoldings(builder: (h) => PortfolioCard(h, c)))
              .toList(),
        ),
      ),
    );
  }

  static final kChartPlaceholderStyle = TextStyle(fontSize: 20);
}

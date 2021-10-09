import 'package:crypto_trader/import_facade/extensions.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:crypto_trader/widgets/portfolio_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Portfolio extends StatefulWidget {
  @override
  State<Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  static final _chartPlaceholderStyle = TextStyle(fontSize: 20);

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) =>
      Flexible(child: Column(children: [_chart(), _currencyCards()]));

  Widget _chart() => Expanded(child: PriceChart());

  Widget _currencyCards() => Wrap(
      children: Currencies.allCryptoCurrencies.mapWithIndex(_asPortfolioCard));

  Widget _asPortfolioCard(Currency currency, int idx) => SizedBox(
        width: 180,
        height: 87,
        child: WithHoldings(
          builder: (holdings) => GestureDetector(
              onTap: () => setState(() => _selectedIndex = idx),
              child: PortfolioCard(holdings, currency, idx == _selectedIndex)),
        ),
      );
}

import 'package:crypto_trader/import_facade/controller.dart';
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
  Currency _selectedCurrency = Currencies.bitcoin;

  @override
  Widget build(BuildContext context) =>
      Flexible(child: Column(children: [_chart(), _currencyCards()]));

  Widget _chart() {
    return Expanded(
        child: EasyFutureBuilder<List<Candle>>(
            future: Environment.prices.candles(_selectedCurrency),
            builder: (List<Candle>? candles) => candles == null
                ? const CupertinoActivityIndicator()
                : PriceChart(currency: _selectedCurrency, candles: candles)));
  }

  Widget _currencyCards() => Wrap(
      children: Currencies.allCryptoCurrencies.map(_asPortfolioCard).toList());

  Widget _asPortfolioCard(Currency currency) => WithHoldings(
        builder: (holdings) => GestureDetector(
          onTap: () {
            print('Tapped card ${currency.name}');
            setState(() => _selectedCurrency = currency);
          },
          child: PortfolioCard(
            holdings: holdings,
            currency: currency,
            isSelected: currency == _selectedCurrency,
          ),
        ),
      );
}

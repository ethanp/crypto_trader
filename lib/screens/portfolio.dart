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
  Widget build(BuildContext context) {
    return Flexible(child: Column(children: [_chart(), _cards()]));
  }

  Widget _chart() {
    return Expanded(
      child: Stack(children: [
        Center(
          child: Text('Chart will go here', style: _chartPlaceholderStyle),
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
            child: SizedBox(
                height: 91,
                child: ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: Currencies.allCryptoCurrencies
                        .mapWithIndex(
                          (currency, idx) => WithHoldings(
                            builder: (holdings) => GestureDetector(
                              onTap: () => setState(() => _selectedIndex = idx),
                              child: PortfolioCard(
                                  holdings, currency, idx == _selectedIndex),
                            ),
                          ),
                        )
                        .toList()))));
  }
}

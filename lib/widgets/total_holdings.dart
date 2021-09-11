import 'package:crypto_trader/data/data_sources.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:flutter/material.dart';

class TotalHoldings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 65),
      child: Card(
        color: Colors.yellow[100],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: FutureBuilder<Holdings>(
            future: Trader.api.getMyHoldings(),
            builder: (ctx, holdings) {
              final textTheme = Theme.of(ctx).textTheme;
              return _displayHoldings(textTheme, holdings.data);
            },
          ),
        ),
      ),
    );
  }

  Widget _displayHoldings(TextTheme textTheme, Holdings? holdings) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _element(
          title: 'Cash available',
          value: holdings?.of(currency: dollars).dollarValue.toString(),
          textTheme: textTheme,
        ),
        _element(
          title: 'Crypto holdings',
          value: holdings?.totalCryptoValue.toString(),
          textTheme: textTheme,
        ),
      ],
    );
  }

  Widget _element({
    required String title,
    required String? value,
    required TextTheme textTheme,
  }) {
    return Row(children: [
      Text('$title: ', style: textTheme.headline4),
      Text('${value ?? 'Loading...'}', style: textTheme.headline3),
    ]);
  }
}

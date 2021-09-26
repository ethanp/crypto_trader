import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:flutter/material.dart';

class TotalHoldings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      color: theme.primaryColor,
      elevation: 15,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: FutureBuilder<Holdings>(
          future: Environment.trader.getMyHoldings(),
          builder: (_ctx, holdings) => Column(children: [
            _cashAvailable(holdings.data, theme.textTheme),
            _cryptoHoldings(holdings.data, theme.textTheme),
          ]),
        ),
      ),
    );
  }

  Widget _cashAvailable(Holdings? holdings, TextTheme textTheme) {
    return _element(
      title: 'Cash available',
      value: holdings?.dollarsOf(Currencies.dollars).toString(),
      textTheme: textTheme,
    );
  }

  Widget _cryptoHoldings(Holdings? holdings, TextTheme textTheme) {
    return _element(
      title: 'Crypto holdings',
      value: holdings?.totalCryptoValue.toString(),
      textTheme: textTheme,
    );
  }

  Widget _element({
    required String title,
    required String? value,
    required TextTheme textTheme,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(children: [
        Text('$title: ', style: textTheme.headline4),
        Text('${value ?? 'Loading...'}', style: textTheme.headline3),
      ]),
    );
  }
}

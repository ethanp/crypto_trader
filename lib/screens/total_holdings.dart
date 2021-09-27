import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';

class TotalHoldings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      color: theme.primaryColor,
      elevation: 15,
      child: _addGradient(
        theme: theme,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: WithHoldings(
            builder: (holdings) => _cryptoHoldings(holdings, theme.textTheme),
          ),
        ),
      ),
    );
  }

  Widget _addGradient({required ThemeData theme, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.primaryColor,
            theme.secondaryHeaderColor,
          ],
        ),
      ),
      child: child,
    );
  }

  Widget _cryptoHoldings(Holdings? holdings, TextTheme textTheme) {
    return _element(
      title: 'Total crypto holdings',
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

import 'package:crypto_trader/import_facade/model.dart';
import 'package:flutter/material.dart';

class PortfolioCard extends StatelessWidget {
  PortfolioCard(this.holdings, this.currency);

  final Holdings? holdings;
  final Currency currency;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: Colors.blue[100],
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(children: [
          _name(),
          _holding(),
          _percentageOfPortfolio(),
        ]),
      ),
    );
  }

  Widget _name() {
    return Row(children: [
      Text(currency.callLetters, style: callLettersTextStyle),
      const SizedBox(width: 10),
      Text(
        currency.name,
        style: currencyNameTextStyle,
      ),
    ]);
  }

  Widget _holding() {
    return Text(
      holdings?.dollarsOf(currency).toString() ?? 'Loading',
      style: holdingValueTextStyle,
    );
  }

  Widget _percentageOfPortfolio() {
    if (holdings == null) return Text('Loading');
    return Row(children: [
      _percentages(),
      const SizedBox(width: 10),
      _difference(),
    ]);
  }

  Widget _percentages() {
    final actualPercentage = holdings!.percentageContaining(currency).round();
    return Text(
      '$actualPercentage% / ${currency.percentAllocation}%',
      style: percentagesTextStyle,
    );
  }

  Widget _difference() {
    final difference = holdings!.difference(currency);
    final Color color = difference >= 0 ? Colors.red : Colors.green;
    return Text('${difference.round()}%',
        style: percentagesTextStyle.copyWith(color: color));
  }

  final callLettersTextStyle = TextStyle(
    fontSize: 17,
    color: Colors.grey[600],
    fontWeight: FontWeight.w700,
  );
  final currencyNameTextStyle = TextStyle(fontSize: 20);
  final percentagesTextStyle = TextStyle(
    fontWeight: FontWeight.w500,
  );
  final holdingValueTextStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
  );
}

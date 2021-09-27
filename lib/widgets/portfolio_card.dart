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
          _percentageOfPortfolio(context),
        ]),
      ),
    );
  }

  Widget _name() {
    return Row(children: [
      Text(currency.callLetters, style: kCallLettersStyle),
      const SizedBox(width: 10),
      Text(
        currency.name,
        style: kCurrencyNameStyle,
      ),
    ]);
  }

  Widget _holding() {
    return Text(
      holdings?.dollarsOf(currency).toString() ?? 'Loading',
      style: kHoldingValueStyle,
    );
  }

  Widget _percentageOfPortfolio(BuildContext context) {
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
      style: kPercentagesStyle,
    );
  }

  Widget _difference() {
    final difference = holdings!.difference(currency);
    final Color color = difference >= 0 ? Colors.red : Colors.green;
    return Text('${difference.round()}%',
        style: kPercentagesStyle.copyWith(color: color));
  }

  final kCallLettersStyle = TextStyle(
    fontSize: 17,
    color: Colors.grey[600],
    fontWeight: FontWeight.w700,
  );
  final kCurrencyNameStyle = TextStyle(fontSize: 20);
  final kPercentagesStyle = TextStyle(
    fontWeight: FontWeight.w500,
  );
  final kHoldingValueStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
  );
}

import 'package:crypto_trader/import_facade/model.dart';
import 'package:flutter/material.dart';

class PortfolioCard extends StatelessWidget {
  PortfolioCard(this.holdings, this.currency, this.isSelected);

  final Holdings? holdings;
  final Currency currency;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 0 : 10,
      color: isSelected ? selectedCardColor : unselectedCardColor,
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
    final Color color = difference >= 0 ? overheldColor : underheldColor;
    return Text('${difference.round()}%', style: _differenceStyle(color));
  }

  TextStyle _differenceStyle(Color color) =>
      percentagesTextStyle.copyWith(color: color);
  final underheldColor = Colors.green;
  final overheldColor = Colors.red;
  final unselectedCardColor = Colors.grey[800];
  final selectedCardColor = Colors.grey[700];
  final callLettersTextStyle = TextStyle(
    fontSize: 17,
    color: Colors.grey[500],
    fontWeight: FontWeight.w700,
  );
  final currencyNameTextStyle = TextStyle(
    fontSize: 20,
  );
  final percentagesTextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    color: Colors.grey[300],
  );
  final holdingValueTextStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: Colors.grey[300],
  );
}

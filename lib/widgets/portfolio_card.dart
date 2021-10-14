import 'package:crypto_trader/import_facade/model.dart';
import 'package:flutter/cupertino.dart';
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
      color: isSelected ? _Style.selectedCardColor : _Style.unselectedCardColor,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(currency.callLetters, style: _Style.callLettersTextStyle),
        const SizedBox(width: 10),
        Text(currency.name, style: _Style.currencyNameTextStyle),
      ],
    );
  }

  Widget _holding() => Text(
        holdings?.dollarsOf(currency).toString() ?? 'Loading',
        style: _Style.holdingValueTextStyle,
      );

  Widget _percentageOfPortfolio() {
    if (holdings == null) return const CupertinoActivityIndicator();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _percentages(),
        const SizedBox(width: 10),
        _difference(),
      ],
    );
  }

  Widget _percentages() {
    final actualPercentage = holdings!.percentageContaining(currency).round();
    return Text(
      '$actualPercentage% / ${currency.percentAllocation}%',
      style: _Style.percentagesTextStyle,
    );
  }

  Widget _difference() {
    final difference = holdings!.difference(currency);
    final Color color =
        difference >= 0 ? _Style.overheldColor : _Style.underheldColor;
    return Text('${difference.round()}%', style: _Style.differenceStyle(color));
  }
}

class _Style {
  static TextStyle differenceStyle(Color color) =>
      percentagesTextStyle.copyWith(color: color);

  static final underheldColor = Colors.green;
  static final overheldColor = Colors.red;
  static final unselectedCardColor = Colors.grey[800];
  static final selectedCardColor = Colors.grey[700];
  static final callLettersTextStyle = TextStyle(
    fontSize: 17,
    color: Colors.grey[500],
    fontWeight: FontWeight.w700,
  );
  static final currencyNameTextStyle = TextStyle(
    fontSize: 17,
  );
  static final percentagesTextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    color: Colors.grey[300],
  );
  static final holdingValueTextStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: Colors.grey[300],
  );
}

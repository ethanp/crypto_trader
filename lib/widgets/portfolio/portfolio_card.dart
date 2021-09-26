import 'package:crypto_trader/data/model/data_model.dart';
import 'package:flutter/material.dart';

class PortfolioCard extends StatelessWidget {
  const PortfolioCard(this.holdings, this.currency);

  final Holdings? holdings;
  final Currency currency;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      color: Colors.blue[100],
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(children: [
          _name(context),
          _holding(context),
          _percentageOfPortfolio(context),
        ]),
      ),
    );
  }

  Widget _name(BuildContext context) {
    return Row(children: [
      Text(
        currency.callLetters,
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(color: Colors.grey[600]),
      ),
      SizedBox(width: 10),
      Text(
        currency.name,
        style: Theme.of(context).textTheme.headline5,
      ),
    ]);
  }

  Widget _holding(BuildContext context) {
    return Text(
      holdings?.dollarsOf(currency).toString() ?? 'Loading',
      style: Theme.of(context).textTheme.headline6,
    );
  }

  Widget _percentageOfPortfolio(BuildContext context) {
    if (holdings == null) return Text('Loading');
    return Row(children: [
      _percentages(Theme.of(context)),
      SizedBox(width: 10),
      _difference(),
    ]);
  }

  Widget _percentages(ThemeData theme) {
    final actualPercentage = holdings!.percentageContaining(currency).round();
    return Text(
      '$actualPercentage% / ${currency.percentAllocation}%',
      style: theme.textTheme.bodyText1,
    );
  }

  Widget _difference() {
    final difference = holdings!.difference(currency);
    final Color color = difference >= 0 ? Colors.red : Colors.green;
    return Text('${difference.round()}%', style: TextStyle(color: color));
  }
}

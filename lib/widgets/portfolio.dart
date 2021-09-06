import 'package:crypto_trader/data/data_sources.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:crypto_trader/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Portfolio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.watch<Notifier>(); // Register for manual UI refreshes.
    return Center(
        child: FutureBuilder<Holdings>(
            future: Trader.api.getMyHoldings(),
            builder: (BuildContext ctx, AsyncSnapshot<Holdings> holdings) =>
                !holdings.hasData
                    ? Text('Loading')
                    : Column(children: [
                        SizedBox(height: 30),
                        Flexible(child: _table(holdings.data!)),
                        _portfolioTotal(
                            holdings.data!, Theme.of(context).textTheme),
                      ])));
  }

  Widget _table(Holdings holdings) {
    return DataTable(
      // TODO(low priority): Sorting is by name, not by this index?
      sortColumnIndex: 5,
      columnSpacing: 26,
      sortAscending: false,
      columns: ['Color', 'Name', 'Value', 'Percentage', 'Allocation', 'Error']
          .map((colName) => DataColumn(label: Text(colName)))
          .toList(),
      rows: holdings.holdings.map((holding) {
        final double percentage = holding.asPercentageOf(holdings);
        return DataRow(
          cells: [
            _colorCircle(holding.currency),
            Text(holding.currency.name),
            Text(holding.dollarValue.toString()),
            Text('${percentage.round()}%'),
            Text('${holding.currency.percentAllocation}%'),
            _difference(holding, holdings),
          ].map((w) => DataCell(Center(child: w))).toList(),
        );
      }).toList(),
    );
  }

  Widget _difference(Holding holding, Holdings holdings) {
    var difference = holding.difference(holdings);
    final color = difference >= 0 ? Colors.red : Colors.green;
    final int differenceInt = difference.abs().round();
    final suffix = difference > 0 ? '% too much' : '% too little';
    return Text('$differenceInt$suffix', style: TextStyle(color: color));
  }

  Widget _colorCircle(Currency currency) {
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        color: supportedCurrencies[currency.callLetters]!.chartColor,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _portfolioTotal(Holdings holdings, TextTheme textTheme) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Total: ', style: textTheme.headline4),
          Text('${holdings.totalValue}', style: textTheme.headline3),
        ],
      );
}

import 'package:crypto_trader/data/data_sources.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Portfolio extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
      child: FutureBuilder<Holdings>(
          future: context.watch<Trader>().getMyHoldings(),
          builder: (BuildContext ctx, AsyncSnapshot<Holdings> holdings) =>
              !holdings.hasData
                  ? Text('Loading')
                  : Column(children: [
                      SizedBox(height: 30),
                      Flexible(child: _table(holdings.data!)),
                      _portfolioTotal(holdings.data!),
                    ])));

  Widget _table(Holdings holdings) {
    return DataTable(
      // TODO this is not working.
      sortColumnIndex: 5,
      sortAscending: false,
      columns: ['Color', 'Name', 'Value', 'Percentage', 'Allocation', 'Error']
          .map((colName) => DataColumn(label: Text(colName)))
          .toList(),
      rows: holdings.holdings.map((holding) {
        final double total = holdings.totalValue.amt;
        final int percentage = (holding.dollarValue.amt / total * 100).round();
        return DataRow(
          cells: [
            _colorCircle(holding.currency),
            Text(holding.currency.name),
            Text(holding.dollarValue.toString()),
            Text('$percentage%'),
            Text('${holding.currency.pctAllocation}%'),
            _difference(holding, percentage),
          ].map((w) => DataCell(w)).toList(),
        );
      }).toList(),
    );
  }

  Widget _difference(Holding holding, int percentage) {
    final difference = percentage - holding.currency.pctAllocation;
    final color = difference >= 0 ? Colors.red : Colors.green;
    final diffTxt = difference > 0
        ? '$difference% too much'
        : '${difference.abs()}% too little';
    return Text('$diffTxt', style: TextStyle(color: color));
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

  Widget _portfolioTotal(Holdings holdings) =>
      Text('Total: ${holdings.totalValue}');
}

import 'package:crypto_trader/data/data_sources.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Portfolio extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FutureBuilder<List<Holding>>(
      future: context.watch<Trader>().getMyHoldings(),
      builder: (BuildContext ctx, AsyncSnapshot<List<Holding>> snapshot) =>
          !snapshot.hasData
              ? Text('Loading')
              : Column(children: [
                  _title(),
                  Flexible(child: _table(snapshot.data!)),
                  _portfolioTotal(snapshot.data!),
                ]));

  Widget _table(List<Holding> snapshot) {
    return DataTable(
      sortColumnIndex: 2,
      sortAscending: true,
      columns: ['Color', 'Name', 'Value', 'Percentage', 'Allocation']
          .map((colName) => DataColumn(label: Text(colName)))
          .toList(),
      rows: snapshot.map((holding) {
        final double total = _totalValue(snapshot).amt;
        final int percentage = (holding.dollarValue.amt / total * 100).round();
        return DataRow(cells: [
          DataCell(_colorCircle(holding.currency)),
          DataCell(Text(holding.currency.name)),
          DataCell(Text(holding.dollarValue.toString())),
          DataCell(Text('$percentage%')),
          DataCell(Text('${holding.currency.pctAllocation}%')),
        ]);
      }).toList(),
    );
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

  Widget _title() => Text('Portfolio');

  Widget _portfolioTotal(List<Holding> snapshot) =>
      Text('Total: ${_totalValue(snapshot)}');

  Dollars _totalValue(List<Holding> snapshot) =>
      snapshot.fold<Dollars>(Dollars(0), (acc, e) => acc + e.dollarValue.amt);
}

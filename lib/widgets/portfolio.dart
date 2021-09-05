import 'package:crypto_trader/data/data_sources.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Portfolio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Holding>>(
      future: context.watch<Trader>().getMyHoldings(),
      builder: (BuildContext ctx, AsyncSnapshot<List<Holding>> snapshot) {
        return Column(children: [
          _title(),
          Flexible(child: _table(snapshot.data)),
          _portfolioTotal(snapshot.data),
        ]);
      },
    );
  }

  Widget _table(List<Holding>? snapshot) {
    if (snapshot == null) return Container();
    return DataTable(
      columns: ['Color', 'Name', 'Value', 'Percentage']
          .map((colName) => DataColumn(label: Text(colName)))
          .toList(),
      rows: snapshot.map((holding) {
        final double total = _totalValue(snapshot)!.amt;
        final int percentage = (holding.dollarValue.amt / total * 100).round();
        return DataRow(cells: [
          DataCell(_colorRef(holding.currency)),
          DataCell(Text(holding.currency.name)),
          DataCell(Text(holding.dollarValue.toString())),
          DataCell(Text('$percentage%')),
        ]);
      }).toList(),
    );
  }

  Widget _colorRef(Currency currency) {
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        color: supportedCurrencies[currency.callLetters]?.chartColor,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _title() => Text('Portfolio');

  Widget _portfolioTotal(List<Holding>? snapshot) {
    final String? total = _totalValue(snapshot).toString();
    return Text('Total: ' + (total ?? "Loading"));
  }

  Dollars? _totalValue(List<Holding>? snapshot) =>
      snapshot?.fold<Dollars>(Dollars(0), (acc, e) => acc + e.dollarValue.amt);
}

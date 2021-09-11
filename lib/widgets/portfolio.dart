import 'package:crypto_trader/data/data_sources.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Portfolio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: FutureBuilder<Holdings>(
      future: Trader.api.getMyHoldings(),
      builder: (ctx, holdings) =>
          !holdings.hasData ? Text('Loading') : _table(holdings.data!),
    ));
  }

  Widget _table(Holdings holdings) {
    return Column(
      children: [
        SizedBox(height: 30),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.brown, width: 5),
                borderRadius: BorderRadius.all(Radius.circular(3)),
              ),
              child: _dataTable(holdings),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dataTable(Holdings holdings) {
    return DataTable(
      columnSpacing: 26,
      columns: ['Name', 'Value', 'Percentage', 'Allocation', 'Error']
          .map((colName) => DataColumn(label: Text(colName)))
          .toList(),
      rows: List<DataRow>.generate(holdings.cryptoHoldings.length, (int idx) {
        final holding = holdings.cryptoHoldings[idx];
        return DataRow(
          color: _alternatinglyGrey(idx),
          cells: [
            Text(
              holding.currency.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(holding.dollarValue.toString()),
            Text('${holding.asPercentageOf(holdings).round()}%'),
            Text('${holding.currency.percentAllocation}%'),
            _difference(holding, holdings),
          ].map((w) => DataCell(Center(child: w))).toList(),
        );
      }),
    );
  }

  /// Grey for even rows, default for odd.
  MaterialStateProperty<Color?> _alternatinglyGrey(int idx) =>
      MaterialStateProperty.resolveWith<Color?>(
          (states) => idx.isEven ? Colors.grey.withOpacity(0.3) : null);

  Widget _difference(Holding holding, Holdings holdings) {
    var difference = holding.difference(holdings);
    final color = difference >= 0 ? Colors.red : Colors.green;
    final int differenceInt = difference.abs().round();
    final suffix = difference > 0 ? '% too much' : '% too little';
    return Text('$differenceInt$suffix', style: TextStyle(color: color));
  }
}

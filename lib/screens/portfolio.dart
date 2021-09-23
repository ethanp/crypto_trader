import 'package:crypto_trader/data/data_sources.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:crypto_trader/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Portfolio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Holdings>(
      future: Environment.trader.getMyHoldings(),
      builder: (ctx, holdings) => !holdings.hasData
          ? Text('Loading')
          : Flexible(
              child: Column(
                children: [
                  Expanded(child: SizedBox(height: 0)),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.brown, width: 5),
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                      child: _dataTable(holdings.data!),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _dataTable(Holdings holdings) {
    final rowData = [
      CellExtractor(
        label: 'Name',
        extractWidget: (holding) => Text(
          holding.currency.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      CellExtractor(
        label: 'Value',
        extractWidget: (holding) => Text(holding.dollarValue.toString()),
      ),
      CellExtractor(
        label: 'Actual',
        extractWidget: (holding) =>
            Text('${holding.asPercentageOf(holdings).round()}%'),
      ),
      CellExtractor(
        label: 'Allocated',
        extractWidget: (holding) =>
            Text('${holding.currency.percentAllocation}%'),
      ),
      CellExtractor(
        label: 'Error',
        extractWidget: (holding) => _difference(holding, holdings),
      ),
    ];
    return DataTable(
        columnSpacing: 10,
        columns:
            rowData.map((data) => DataColumn(label: Text(data.label))).toList(),
        rows: holdings.cryptoHoldings
            .zipWithIndex((Holding holding, int idx) => DataRow(
                color: _oddGreyEvenWhite(idx),
                cells: rowData.map((extractor) {
                  var widget = extractor.extractWidget(holding);
                  if (extractor.label != 'Name') widget = Center(child: widget);
                  return DataCell(widget);
                }).toList())));
  }

  MaterialStateProperty<Color?> _oddGreyEvenWhite(int idx) =>
      MaterialStateProperty.resolveWith<Color?>(
          (states) => idx.isEven ? Colors.grey.withOpacity(0.4) : null);

  Widget _difference(Holding holding, Holdings holdings) {
    final difference = holding.difference(holdings);
    final color = difference >= 0 ? Colors.red : Colors.green;
    return Text('${difference.round()}%', style: TextStyle(color: color));
  }
}

class CellExtractor {
  const CellExtractor({required this.label, required this.extractWidget});

  final String label;
  final Widget Function(Holding) extractWidget;
}

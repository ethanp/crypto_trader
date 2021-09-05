import 'package:crypto_trader/data/data_sources.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:fl_chart/fl_chart.dart';
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
          _chart(snapshot.data),
          _portfolioTotal(snapshot.data),
        ]);
      },
    );
  }

  Widget _chart(List<Holding>? snapshot) {
    return Flexible(
      child: Column(children: [
        Flexible(
            child: PieChart(
                PieChartData(sections: [PieChartSectionData(value: 5)]))),
        Flexible(
          child: ListView.builder(
            itemBuilder: (ctx, idx) => _row(idx, snapshot),
            itemCount: currencies.length,
          ),
        ),
      ]),
    );
  }

  Text _title() => Text('Portfolio');

  Text _portfolioTotal(List<Holding>? snapshot) {
    final String? total = snapshot
        ?.fold<Dollars>(Dollars(0), (acc, e) => acc + e.dollarValue.amt)
        .toString();
    return Text('Total: ' + (total ?? "Loading"));
  }

  Row _row(int idx, List<Holding>? snapshot) {
    return Row(children: [
      Flexible(child: Text(currencies[idx].name)),
      Text(snapshot?[idx].dollarValue.toString() ?? "Loading"),
    ]);
  }
}

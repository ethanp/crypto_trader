import 'package:crypto_trader/data/data_sources.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:fl_chart/fl_chart.dart';
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
          Flexible(child: _chart(snapshot.data)),
          _portfolioTotal(snapshot.data),
        ]);
      },
    );
  }

  Widget _chart(List<Holding>? snapshot) {
    return Row(children: [
      Flexible(child: _pieChart(snapshot)),
      SizedBox(height: 10),
      Flexible(child: _legend(snapshot)),
    ]);
  }

  Widget _pieChart(List<Holding>? snapshot) {
    return PieChart(PieChartData(
      sections: snapshot?.map((holding) => _section(holding)).toList(),
    ));
  }

  PieChartSectionData _section(Holding holding) {
    return PieChartSectionData(
      value: holding.dollarValue.amt,
      title: '',
      badgeWidget: _sectionLabel(holding),
      color: holding.currency.chartColor,
    );
  }

  Widget _sectionLabel(Holding holding) {
    final Widget currencyName = Text(
      holding.currency.name,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
    final Widget currencyValue = Text(holding.dollarValue.toString());
    return SizedBox(
      height: 40,
      child: Column(children: [currencyName, currencyValue]),
    );
  }

  Widget _legend(List<Holding>? snapshot) {
    return ListView.builder(
      itemBuilder: (ctx, idx) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              color: currencies[idx].chartColor,
              shape: BoxShape.circle,
            ),
          ),
          Text(currencies[idx].name),
          Text(snapshot?[idx].dollarValue.toString() ?? "Loading"),
        ]
            .map(
              (w) => Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: w,
                ),
              ),
            )
            .toList(),
      ),
      itemCount: currencies.length,
    );
  }

  Widget _title() => Text('Portfolio');

  Widget _portfolioTotal(List<Holding>? snapshot) {
    final String? total = snapshot
        ?.fold<Dollars>(Dollars(0), (acc, e) => acc + e.dollarValue.amt)
        .toString();
    return Text('Total: ' + (total ?? "Loading"));
  }
}

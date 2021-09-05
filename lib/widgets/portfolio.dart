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
    return ListView.builder(
      itemBuilder: (ctx, idx) {
        final double total = (_totalValue(snapshot)?.amt ?? 1);
        final double thisOne = (snapshot?[idx].dollarValue.amt ?? 0);
        final int percentage = (thisOne / total * 100).round();
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _colorRef(idx),
            Text(currencies[idx].name),
            Text(snapshot?[idx].dollarValue.toString() ?? "Loading"),
            Text('$percentage%')
          ].map(_addPadding).toList(),
        );
      },
      itemCount: currencies.length,
    );
  }

  Widget _colorRef(int idx) {
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        color: currencies[idx].chartColor,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _addPadding(w) => Padding(
        padding: const EdgeInsets.all(2),
        child: w,
      );

  Widget _title() => Text('Portfolio');

  Widget _portfolioTotal(List<Holding>? snapshot) {
    final String? total = _totalValue(snapshot).toString();
    return Text('Total: ' + (total ?? "Loading"));
  }

  Dollars? _totalValue(List<Holding>? snapshot) =>
      snapshot?.fold<Dollars>(Dollars(0), (acc, e) => acc + e.dollarValue.amt);
}

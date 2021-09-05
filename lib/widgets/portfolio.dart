import 'package:crypto_trader/data/data_sources.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Portfolio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Portfolio'),
        FutureBuilder<List<Holding>>(
            future: context.watch<Trader>().getMyHoldings(),
            builder: (BuildContext ctx, AsyncSnapshot<List<Holding>> snapshot) {
              return Flexible(
                child: ListView.separated(
                  itemBuilder: (ctx, idx) => Row(children: [
                    Flexible(child: Text(currencies[idx].name)),
                    Text(snapshot.hasData
                        ? snapshot.data![idx].dollarValue.toString()
                        : "Loading"),
                  ]),
                  separatorBuilder: (ctx, idx) => SizedBox(height: 0),
                  itemCount: currencies.length,
                ),
              );
            })
      ],
    );
  }
}

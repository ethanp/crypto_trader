import 'package:crypto_trader/data/data_sources.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BitcoinPrice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            'Current Bitcoin price:',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        FutureBuilder<Dollars>(
          future: context.read<Prices>().getCurrentPrice(of: bitcoin),
          builder: (BuildContext ctx, AsyncSnapshot<Dollars> snapshot) => Text(
              snapshot.hasData
                  ? snapshot.data!.toString()
                  : 'Not connected or Loading...',
              style: Theme.of(ctx).textTheme.headline3),
        ),
        SizedBox(height: 50),
        Center(
          child: Text(
            'Current Bitcoin holdings:',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        FutureBuilder<List<Holding>>(
          future: context.read<Trader>().getMyHoldings(),
          builder: (BuildContext ctx, AsyncSnapshot<List<Holding>> snapshot) =>
              Text(
                  snapshot.hasData
                      ? snapshot.data!
                          .firstWhere((element) => element.currency == bitcoin)
                          .dollarValue
                          .toString()
                      : 'Not connected or Loading...',
                  style: Theme.of(ctx).textTheme.headline3),
        )
      ],
    );
  }
}

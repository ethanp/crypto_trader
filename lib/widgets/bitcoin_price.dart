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
        FutureBuilder<String>(
          future: context.read<Prices>().getCurrentPrice(of: bitcoin),
          builder: (BuildContext ctx, AsyncSnapshot<String> snapshot) => Text(
              snapshot.hasData ? snapshot.data! : 'Not connected or Loading...',
              style: Theme.of(context).textTheme.headline3),
        ),
        FutureBuilder<String>(
          future: context.read<Trader>().getMyHoldings().then((value) => value
              .singleWhere((element) => element.currency == bitcoin)
              .dollarValue
              .toString()),
          builder: (BuildContext ctx, AsyncSnapshot<String> snapshot) => Text(
              snapshot.hasData ? snapshot.data! : 'Not connected or Loading...',
              style: Theme.of(context).textTheme.headline3),
        )
      ],
    );
  }
}

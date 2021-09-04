import 'package:crypto_trader/data_model.dart';
import 'package:crypto_trader/data_sources.dart';
import 'package:flutter/material.dart';

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
          future: CoinbaseProPrices().getCurrentPrice(of: bitcoin),
          builder: (BuildContext ctx, AsyncSnapshot<String> snapshot) => Text(
              snapshot.hasData ? snapshot.data! : 'Not connected or Loading...',
              style: Theme.of(context).textTheme.headline3),
        ),
      ],
    );
  }
}

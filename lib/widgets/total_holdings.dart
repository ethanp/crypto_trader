import 'package:crypto_trader/data/data_sources.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:flutter/material.dart';

class TotalHoldings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 65),
      child: Card(
        color: Colors.yellow[100],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: FutureBuilder<Holdings>(
            future: Trader.api.getMyHoldings(),
            builder: (ctx, holdings) => _displayHoldings(ctx, holdings.data),
          ),
        ),
      ),
    );
  }

  Widget _displayHoldings(BuildContext context, Holdings? holdings) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Total crypto holdings: ',
          style: Theme.of(context).textTheme.headline4,
        ),
        Text(
          '${holdings?.totalCryptoValue ?? 'Loading...'}',
          style: Theme.of(context).textTheme.headline3,
        ),
      ],
    );
  }
}

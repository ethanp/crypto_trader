import 'package:crypto_trader/data/data_sources.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpendButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final trader = context.read<Trader>();
        trader.spend(Dollars(.01));
      },
      child: Text('Spend'),
    );
  }
}

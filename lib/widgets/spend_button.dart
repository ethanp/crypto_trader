import 'package:crypto_trader/data/data_sources.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:flutter/material.dart';

class SpendButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Trader.api.spend(Dollars(.01)),
      child: Text('Spend \$0.01'),
    );
  }
}

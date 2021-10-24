import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Display total holdings and earnings.
class HoldingsFacts extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Card(
      margin: EdgeInsets.zero,
      child: Container(
          decoration: _gradient,
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _cryptoHoldings(),
              _cryptoEarnings(),
            ],
          )));

  BoxDecoration get _gradient => BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomRight,
          colors: [Colors.grey[800]!, Colors.grey[900]!]));

  Widget _cryptoHoldings() => WithHoldings(
      builder: (holdings) => LineItem(
          title: 'Holdings', value: holdings?.totalCryptoValue.toString()));

  Widget _cryptoEarnings() => WithHoldings(
      builder: (holdings) => WithEarnings(
          builder: (Dollars? earnings) => LineItem(
              title: 'Earnings',
              value: earnings?.toString(),
              percent: _percent(holdings, earnings))));

  double _percent(Holdings? holdings, Dollars? earnings) {
    // Default 1 instead of 0 so we don't get a NaN during division below.
    final total = holdings?.totalCryptoValue.amt ?? 1.0;
    final earnedAmt = earnings?.amt ?? 0.0;
    return earnedAmt / total * 100;
  }
}

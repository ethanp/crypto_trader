import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';

/// Displays total holdings and earnings.
class HoldingsFacts extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Card(
      margin: EdgeInsets.zero,
      child: Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Container(
              padding: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                  gradient: _gradient,
                  boxShadow: const [BoxShadow(blurRadius: 2, spreadRadius: 2)],
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100))),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [_cryptoHoldings(), _cryptoEarnings()]))));

  Gradient get _gradient => LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomRight,
      colors: [Colors.grey[900]!.withBlue(50), Colors.black.withBlue(10)]);

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
    // Default 1 instead of 0 to avoid NaN during division below.
    final total = holdings?.totalCryptoValue.amt ?? 1.0;
    final earnedAmt = earnings?.amt ?? 0.0;
    return earnedAmt / total * 100;
  }
}

import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';

/// Displays total holdings and earnings.
class HoldingsFacts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return styledAsAppBarBottom(holdingsAndEarnings());
  }

  Widget styledAsAppBarBottom(Widget child) {
    const roundedBottomCorners = BorderRadius.only(
      bottomLeft: Radius.circular(100),
      bottomRight: Radius.circular(100),
    );
    final shadedRoundedAppBarBottom = BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomRight,
          colors: [Colors.grey[900]!.withBlue(50), Colors.black.withBlue(10)]),
      boxShadow: const [BoxShadow(blurRadius: 2, spreadRadius: 2)],
      borderRadius: roundedBottomCorners,
    );
    return Container(
      // Spacing between bottom of text and bottom of extended AppBar.
      padding: const EdgeInsets.only(bottom: 14),
      decoration: shadedRoundedAppBarBottom,
      child: child,
    );
  }

  Widget holdingsAndEarnings() {
    final holdings = WithHoldings(
      builder: (holdings) => LineItem(
        title: 'Holdings',
        value: holdings?.totalCryptoValue.toString(),
      ),
    );
    final earnings = WithHoldings(
      builder: (holdings) => WithEarnings(
        builder: (Dollars? earnings) {
          final total = holdings?.totalCryptoValue.amt ?? 1.0;
          final earnedAmt = earnings?.amt ?? 0.0;
          final percent = earnedAmt / total * 100;
          return LineItem(
            title: 'Earnings',
            value: earnings?.toString(),
            percent: percent,
          );
        },
      ),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [holdings, earnings],
    );
  }
}

import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';

class TotalHoldings extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Card(
      margin: EdgeInsets.zero,
      elevation: 15,
      child: Container(
          decoration: _gradient,
          child: Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 25),
              child: Column(children: [
                _cryptoHoldings(),
                _cryptoEarnings(),
              ]))));

  BoxDecoration get _gradient => BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomRight,
          colors: [_Style.appBarGradientTop, _Style.appBarGradientBottom]));

  Widget _cryptoHoldings() => WithHoldings(
      builder: (holdings) => _element(
          title: 'Crypto holdings',
          value: holdings?.totalCryptoValue.toString()));

  Widget _cryptoEarnings() => WithHoldings(
      builder: (holdings) => WithEarnings(
          builder: (Dollars? earnings) => _element(
              title: 'Crypto earnings',
              value: earnings?.toString(),
              percent: _percent(holdings, earnings))));

  double _percent(Holdings? holdings, Dollars? earnings) {
    // Default 1 instead of 0 so we don't get a NaN during division below.
    final total = holdings?.totalCryptoValue.amt ?? 1.0;
    final earnedAmt = earnings?.amt ?? 0.0;
    return earnedAmt / total * 100;
  }

  Widget _element({
    required String title,
    required String? value,
    double? percent,
  }) =>
      Padding(
          padding: const EdgeInsets.all(5),
          child: Row(children: [
            Text('$title: ', style: _Style.labelStyle),
            Text('${value ?? 'Loading...'}', style: _Style.amountStyle),
            if (percent != null)
              Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: Text(
                    '+${percent.toInt()}%',
                    style: _Style.percentStyle,
                  ))
          ]));
}

class _Style {
  static final labelStyle = TextStyle(
    color: Colors.grey[100],
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );
  static final amountStyle = TextStyle(
    color: Colors.green[300],
    fontSize: 20,
  );
  static final percentStyle = amountStyle.copyWith(fontSize: 13);

  static final appBarGradientTop = Colors.grey[800]!;
  static final appBarGradientBottom = Colors.grey[900]!;
}

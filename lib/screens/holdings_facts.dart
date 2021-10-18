import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Display total holdings and earnings.
class HoldingsFacts extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Card(
      margin: EdgeInsets.zero,
      elevation: 15,
      child: Container(
          decoration: _gradient,
          padding: const EdgeInsets.only(left: 7, right: 3),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_cryptoHoldings(), _cashAvailable()],
            ),
            _cryptoEarnings(),
          ])));

  BoxDecoration get _gradient => BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomRight,
          colors: [_Style.appBarGradientTop, _Style.appBarGradientBottom]));

  Widget _cryptoHoldings() => WithHoldings(
      builder: (holdings) => _element(
          title: 'Holdings', value: holdings?.totalCryptoValue.toString()));

  Widget _cashAvailable() => WithHoldings(
      builder: (holdings) => _element(
          // TODO move this to above the cards
          title: 'Cash available Move this to above the cards',
          value: holdings?.dollarsOf(Currencies.dollars).toString()));

  Widget _cryptoEarnings() => WithHoldings(
      builder: (holdings) => WithEarnings(
          builder: (Dollars? earnings) => _element(
              // TODO move this to be in a Row after Holdings,
              //  instead of a column as it is now.
              title: 'Earnings',
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
            MyText('$title: ', style: _Style.labelStyle),
            if (value != null)
              MyText(value, style: _Style.amountStyle)
            else
              const CupertinoActivityIndicator(),
            if (percent != null)
              Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: MyText(
                    '+${percent.toInt()}%',
                    style: _Style.percentStyle,
                  ))
          ]));
}

class _Style {
  static final labelStyle = TextStyle(
    color: Colors.grey[300],
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );
  static final amountStyle = TextStyle(
    color: Colors.green[300],
    fontSize: 20,
  );
  static final percentStyle = amountStyle.copyWith(fontSize: 13);

  static final appBarGradientTop = Colors.grey[800]!;
  static final appBarGradientBottom = Colors.grey[900]!;
}

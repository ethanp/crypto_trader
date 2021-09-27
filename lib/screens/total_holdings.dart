import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';

class TotalHoldings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: kPrimaryColor,
      elevation: 15,
      child: _addGradient(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: WithHoldings(
            builder: (holdings) => _cryptoHoldings(holdings),
          ),
        ),
      ),
    );
  }

  Widget _addGradient({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            kAppBarGradientTop,
            kAppBarGradientBottom,
          ],
        ),
      ),
      child: child,
    );
  }

  Widget _cryptoHoldings(Holdings? holdings) {
    return _element(
      title: 'Total crypto holdings',
      value: holdings?.totalCryptoValue.toString(),
    );
  }

  Widget _element({
    required String title,
    required String? value,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(children: [
        Text('$title: ', style: kHoldingsLabelStyle),
        Text('${value ?? 'Loading...'}', style: kHoldingsAmountStyle),
      ]),
    );
  }

  static final kHoldingsLabelStyle = TextStyle(
    color: Colors.grey[100],
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );
  static final kHoldingsAmountStyle = TextStyle(
    color: Colors.green[300],
    fontSize: 20,
  );

  static final kAppBarGradientTop = kPrimaryColor;
  static final kAppBarGradientBottom = Color(0xFF0D47A1);
}

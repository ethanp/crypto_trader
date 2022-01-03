import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';

abstract class TransactCard extends StatelessWidget {
  Widget title();

  Widget body();

  @override
  Widget build(BuildContext context) => WithHoldings(
      builder: (holdings) => Card(
          shape: _roundedRectOuter(),
          elevation: 1,
          child: Container(
              // This is the *max needed height*. It is the size of the
              // spend_card when there is an amount validation error text
              // displaying.
              height: 113,
              padding: const EdgeInsets.only(bottom: 6),
              decoration: _roundedRectInner(),
              width: MediaQuery.of(context).size.width / 2.2,
              child: Column(children: [title(), body()]))));

  RoundedRectangleBorder _roundedRectOuter() =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));

  BoxDecoration _roundedRectInner() => BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.grey[700]!.withOpacity(0.6));
}

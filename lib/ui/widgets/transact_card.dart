import 'package:crypto_trader/import_facade/ui.dart';
import 'package:flutter/material.dart';

abstract class TransactCard extends StatelessWidget {
  static const borderRadius = BorderRadius.all(Radius.circular(10));

  Widget title();

  Widget body();

  @override
  Widget build(BuildContext context) => WithHoldings(
      builder: (holdings) => Card(
          elevation: 1,
          shape: const RoundedRectangleBorder(
            borderRadius: TransactCard.borderRadius,
          ),
          child: Container(
              // This is the *max needed height*. It is the size of the
              // spend_card when there is an amount validation error text
              // displaying.
              height: 113,
              width: MediaQuery.of(context).size.width / 2.2,
              padding: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                borderRadius: TransactCard.borderRadius,
                color: Colors.grey[700]!.withOpacity(0.6),
              ),
              child: Column(children: [title(), body()]))));
}

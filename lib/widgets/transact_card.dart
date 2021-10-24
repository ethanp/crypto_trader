import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';

abstract class TransactCard extends StatelessWidget {
  Widget title();

  Widget body();

  @override
  Widget build(BuildContext context) => WithHoldings(builder: (holdings) {
        return Card(
            shape: _roundedRectOuter(),
            elevation: 5,
            child: Container(
                decoration: _roundedRectInner(),
                height: MediaQuery.of(context).size.height / 6,
                width: MediaQuery.of(context).size.width / 2.2,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: title(),
                  ),
                  body()
                ])));
      });

  RoundedRectangleBorder _roundedRectOuter() => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      );

  BoxDecoration _roundedRectInner() => BoxDecoration(
        border: Border.all(color: Colors.green[900]!),
        borderRadius: BorderRadius.circular(20),
        color: Colors.red[200]!.withOpacity(.3),
      );
}
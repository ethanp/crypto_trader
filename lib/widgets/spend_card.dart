import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SpendCard extends StatefulWidget {
  @override
  State<SpendCard> createState() => _SpendCardState();
}

class _SpendCardState extends State<SpendCard> {
  /// Lives in State so that it survives across Widget re-builds.
  late final TextEditingController fieldController;

  @override
  void initState() {
    fieldController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WithHoldings(
      builder: (holdings) {
        _fillFieldWithInitialValue(holdings);
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green[900]!),
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[400]!.withOpacity(.3),
            ),
            height: MediaQuery.of(context).size.height / 6,
            width: MediaQuery.of(context).size.width / 2.2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 0),
                  MyText(
                    'Buy ${holdings?.shortest.currency.name ?? '(Loading...)'}',
                    fontSize: 18,
                    color: Colors.grey[300],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AmountField(fieldController),
                      TransactButton(
                        Environment.trader.spend,
                        Colors.lightBlueAccent,
                        fieldController.text,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _fillFieldWithInitialValue(Holdings? holdings) {
    if (holdings != null) {
      fieldController.text = NumberFormat('##0.##')
          .format(holdings.dollarsOf(Currencies.dollars).rounded);
    }
  }
}

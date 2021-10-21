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
          shape: _roundedRectOuter(),
          elevation: 5,
          child: Container(
            decoration: _roundedRectInner(),
            height: MediaQuery.of(context).size.height / 6,
            width: MediaQuery.of(context).size.width / 2.2,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _title(holdings),
                  _body(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Row _body() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AmountField(fieldController),
          // TODO(BIG BUG): On my phone (ie. old version of the app), when
          //  you change the amount and hit "play" it still spends your
          //  *entire* cash available! Try replicating it in the Fake
          //  environment :)
          TransactButton(
            Environment.trader.spend,
            Colors.yellow.withOpacity(.75),
            fieldController.text,
          ),
        ],
      );

  MyText _title(Holdings? holdings) => MyText(
        'Buy ${holdings?.shortest.currency.name ?? '(Loading...)'}',
        fontSize: 18,
        color: Colors.grey[300],
      );

  BoxDecoration _roundedRectInner() => BoxDecoration(
        border: Border.all(color: Colors.green[900]!),
        borderRadius: BorderRadius.circular(20),
        color: Colors.blue[400]!.withOpacity(.3),
      );

  RoundedRectangleBorder _roundedRectOuter() => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      );

  void _fillFieldWithInitialValue(Holdings? holdings) {
    if (holdings != null) {
      fieldController.text = NumberFormat('##0.##')
          .format(holdings.dollarsOf(Currencies.dollars).rounded);
    }
  }
}

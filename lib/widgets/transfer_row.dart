import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SpendRow extends StatefulWidget {
  @override
  State<SpendRow> createState() => _SpendRowState();
}

class _SpendRowState extends State<SpendRow> {
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
        return Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AmountField(fieldController),
              const SizedBox(width: 20),
              TransactButton(
                Environment.trader.spend,
                'Buy ${holdings?.shortest.currency.name ?? '(Loading...)'}',
                fieldController.text,
              ),
            ],
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

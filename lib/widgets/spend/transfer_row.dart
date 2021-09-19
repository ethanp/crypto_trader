import 'package:crypto_trader/data/data_sources.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'amount_field.dart';
import 'spend_button.dart';

class TransferRow extends StatelessWidget {
  final Future<String> Function(Dollars) action;
  final String Function(Holdings) buttonText;
  final Dollars Function(Holdings) initialInput;

  const TransferRow({
    required this.action,
    required this.buttonText,
    required this.initialInput,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Holdings>(
      future: Environment.trader.getMyHoldings(),
      builder: (ctx, snapshot) {
        if (snapshot.data == null) return Text('Loading');
        final Holdings holdings = snapshot.data!;
        final fieldController = TextEditingController(
          text: NumberFormat('##0.##').format(initialInput(holdings).rounded),
        );
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              AmountField(fieldController),
              SizedBox(width: 15),
              SpendButton(action, buttonText, fieldController, holdings),
            ],
          ),
        );
      },
    );
  }
}

import 'package:crypto_trader/data/data_sources.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'amount_field.dart';
import 'spend_button.dart';

/// Allows you to dismiss the keyboard, but leaves the value in the field the
/// same.
class TransferRow extends StatefulWidget {
  const TransferRow({
    required this.initialInput,
    required this.action,
    required this.buttonText,
  });

  final Dollars Function(Holdings) initialInput;
  final Future<String> Function(Dollars) action;
  final String Function(Holdings) buttonText;

  @override
  State<TransferRow> createState() => _TransferRowState();
}

class _TransferRowState extends State<TransferRow> {
  late final TextEditingController fieldController;

  @override
  void initState() {
    fieldController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Holdings>(
      future: Environment.trader.getMyHoldings(),
      builder: (ctx, snapshot) {
        _initFieldText(snapshot.data);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              AmountField(fieldController),
              SizedBox(width: 15),
              SpendButton(
                widget.action,
                widget.buttonText,
                fieldController,
                snapshot.data,
              ),
            ],
          ),
        );
      },
    );
  }

  void _initFieldText(Holdings? holdings) {
    if (holdings != null && fieldController.text.isEmpty)
      fieldController.text =
          NumberFormat('##0.##').format(widget.initialInput(holdings).rounded);
  }
}

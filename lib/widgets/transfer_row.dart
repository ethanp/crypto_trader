import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A [Row] that holds a [TextField] and a [Button]
///
/// Allows you to dismiss the keyboard, but leaves the value in the field the
/// same.
class TransferRow extends StatefulWidget {
  /// A [Row] that holds a [TextField] and a [Button]
  ///
  /// Allows you to dismiss the keyboard, but leaves the value in the field the
  /// same.
  const TransferRow({
    required this.initialInput,
    required this.action,
    required this.buttonText,
  });

  /// Returns the default [Dollars] to input in the [TextField].
  final Dollars Function(Holdings) initialInput;

  /// What the [Button] does.
  final Future<String> Function(Dollars) action;

  /// Returns the label for the [Button].
  final String Function(Holdings) buttonText;

  @override
  State<TransferRow> createState() => _TransferRowState();
}

class _TransferRowState extends State<TransferRow> {
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
              SpendButton(
                widget.action,
                widget.buttonText,
                fieldController,
                holdings,
              ),
            ],
          ),
        );
      },
    );
  }

  void _fillFieldWithInitialValue(Holdings? holdings) {
    if (holdings != null) {
      fieldController.text =
          NumberFormat('##0.##').format(widget.initialInput(holdings).rounded);
    }
  }
}

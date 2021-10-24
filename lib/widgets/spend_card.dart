import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/util.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SpendCard extends TransactCard {
  @override
  Widget title() => Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: WithHoldings(
          builder: (holdings) => MyText(
              'Buy ${holdings?.shortest.currency.name ?? '(Loading...)'}',
              fontSize: 18,
              color: Colors.grey[300])));

  @override
  Widget body() => SpendCardInner();
}

class SpendCardInner extends StatefulWidget {
  @override
  State<SpendCardInner> createState() => _SpendCardInnerState();
}

class _SpendCardInnerState extends State<SpendCardInner> {
  /// Lives in State so that it survives across Widget re-builds.
  late final TextEditingController _fieldController;
  late final ValueNotifier<String> _currentFieldText;

  @override
  void initState() {
    _fieldController = TextEditingController();
    _currentFieldText = ValueNotifier('');
    _fieldController
        .addListener(() => _currentFieldText.value = _fieldController.text);
    super.initState();
  }

  @override
  void dispose() {
    // Required in docs:
    // https://api.flutter.dev/flutter/widgets/TextEditingController-class.html
    _fieldController.dispose();
    _currentFieldText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => WithHoldings(
        builder: (holdings) {
          // Different placement of this may lead to different refresh semantics.
          _fillFieldWithInitialValue(holdings);
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AmountField(_fieldController),
              TransactButton(
                (amount) => SpendCommand(amount),
                Colors.yellow.withOpacity(.75),
                _currentFieldText,
              ),
            ],
          );
        },
      );

  void _fillFieldWithInitialValue(Holdings? holdings) {
    if (holdings != null) {
      _fieldController.text = NumberFormat('##0.##')
          .format(holdings.dollarsOf(Currencies.dollars).rounded);
    }
  }
}

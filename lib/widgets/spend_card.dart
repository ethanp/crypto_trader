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
  Widget build(BuildContext context) => WithHoldings(builder: (holdings) {
        // Different placement of this may lead to different refresh semantics.
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
                        children: [_title(holdings), _body()]))));
      });

  Widget _body() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AmountField(_fieldController),
          TransactButton(
            Environment.trader.spend,
            Colors.yellow.withOpacity(.75),
            _currentFieldText,
          ),
        ],
      );

  Widget _title(Holdings? holdings) => MyText(
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
      _fieldController.text = NumberFormat('##0.##')
          .format(holdings.dollarsOf(Currencies.dollars).rounded);
    }
  }
}

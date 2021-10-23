import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DepositCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MultiProvider(
      providers: [DepositCardValue.provider()],
      builder: (context, child) => WithHoldings(builder: (holdings) {
            final state = context.watch<DepositCardValue>();
            return Card(
                shape: _roundedRectOuter(),
                elevation: 5,
                child: Container(
                    decoration: _roundedRectInner(),
                    height: MediaQuery.of(context).size.height / 6,
                    width: MediaQuery.of(context).size.width / 2.2,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [_title(), _body(state)])));
          }));

  RoundedRectangleBorder _roundedRectOuter() => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      );

  BoxDecoration _roundedRectInner() => BoxDecoration(
        border: Border.all(color: Colors.green[900]!),
        borderRadius: BorderRadius.circular(20),
        color: Colors.red[200]!.withOpacity(.3),
      );

  MyText _title() => MyText(
        'Deposit Dollars',
        fontSize: 18,
        color: Colors.grey[300],
      );

  Row _body(DepositCardValue state) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DepositDropdown(state.value),
          TransactButton(
            Environment.trader.deposit,
            Colors.yellow.withOpacity(.7),
            state,
          ),
        ],
      );
}

class DepositCardValue extends ValueNotifier<String> {
  DepositCardValue() : super(50.toString());

  static ChangeNotifierProvider provider() =>
      ChangeNotifierProvider(create: (_) => DepositCardValue());
}

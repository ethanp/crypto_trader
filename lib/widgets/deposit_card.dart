import 'package:crypto_trader/import_facade/util.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DepositCard extends TransactCard {
  @override
  Widget title() => MyText(
        'Deposit Dollars',
        fontSize: 18,
        color: Colors.grey[300],
      );

  @override
  Widget body() {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => DepositCardValue())],
      builder: (context, child) {
        final state = context.watch<DepositCardValue>();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DepositDropdown(state.value),
            TransactButton(
              (amount) => DepositCommand(amount),
              Colors.yellow.withOpacity(.7),
              state,
            ),
          ],
        );
      },
    );
  }
}

class DepositCardValue extends ValueNotifier<String> {
  DepositCardValue() : super(50.toString());
}

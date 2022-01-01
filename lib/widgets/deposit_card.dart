import 'package:crypto_trader/import_facade/util.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:crypto_trader/widgets/transact_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DepositCard extends TransactCard {
  @override
  Widget title() => Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 7),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        MyText('Deposit ', fontSize: 16, color: Colors.grey[400]),
        MyText('Dollars',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[300]))
      ]));

  @override
  Widget body() {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => DepositCardValue())],
      builder: (context, child) {
        final state = context.watch<DepositCardValue>();
        return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          DepositDropdown(state.value),
          TransactButton((amount) => DepositCommand(amount), state),
        ]);
      },
    );
  }
}

class DepositCardValue extends ValueNotifier<String> {
  DepositCardValue() : super(50.toString());
}

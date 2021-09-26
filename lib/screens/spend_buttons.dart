import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';

class SpendButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 80, bottom: 60),
      child: Column(children: [_deposit(), _spend()]),
    );
  }

  TransferRow _deposit() {
    return TransferRow(
      action: Environment.trader.deposit,
      buttonText: (holdings) => 'Deposit Dollars',
      initialInput: (holdings) => Dollars(50),
    );
  }

  TransferRow _spend() {
    return TransferRow(
      action: Environment.trader.spend,
      buttonText: (holdings) => 'Buy ${holdings.shortest.currency.name}',
      initialInput: (holdings) => holdings.dollarsOf(Currencies.dollars),
    );
  }
}

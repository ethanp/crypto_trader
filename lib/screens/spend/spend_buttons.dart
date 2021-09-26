import 'package:crypto_trader/data/controller/data_controller.dart';
import 'package:crypto_trader/data/model/data_model.dart';
import 'package:flutter/material.dart';

import 'components/transfer_row.dart';

class SpendButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 80, bottom: 60),
      child: Column(children: [
        TransferRow(
          action: Environment.trader.deposit,
          buttonText: (holdings) => 'Deposit Dollars',
          initialInput: (holdings) => Dollars(50),
        ),
        TransferRow(
          action: Environment.trader.spend,
          buttonText: (holdings) => 'Buy ${holdings.shortest.currency.name}',
          initialInput: (holdings) => holdings.dollarsOf(Currencies.dollars),
        )
      ]),
    );
  }
}

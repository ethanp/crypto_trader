import 'package:crypto_trader/data/data_sources.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:flutter/material.dart';

import 'components/transfer_row.dart';

class SpendButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(children: [
        TransferRow(
          action: Environment.trader.deposit,
          buttonText: (holdings) => 'Deposit Dollars',
          initialInput: (holdings) => Dollars(50),
        ),
        TransferRow(
          action: Environment.trader.spend,
          buttonText: (holdings) => 'Buy ${holdings.shortest.currency.name}',
          initialInput: (holdings) => holdings.dollarsOf(dollars),
        )
      ]),
    );
  }
}

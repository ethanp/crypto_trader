import 'package:crypto_trader/data/data_sources.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:crypto_trader/helpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SpendButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      // TODO it reloads the info after spend but not after deposit.
      //  What's the difference between the two implementation-wise?
      //  Not much?? Tried it again and it still is so Sept 18, '21.
      children: [
        TransferRow(
          transact: Environment.trader.deposit,
          buttonText: (holdings) => 'Transfer from Schwab',
          initialInput: (holdings) => Dollars(50),
        ),
        TransferRow(
          transact: Environment.trader.spend,
          buttonText: (holdings) => 'Buy ${holdings.shortest.currency.name}',
          initialInput: (holdings) => holdings.of(dollars),
        )
      ],
    );
  }
}

class TransferRow extends StatelessWidget {
  final Future<String> Function(Dollars) transact;
  final String Function(Holdings) buttonText;
  final Dollars Function(Holdings) initialInput;

  const TransferRow({
    required this.transact,
    required this.buttonText,
    required this.initialInput,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Holdings>(
      future: Environment.trader.getMyHoldings(),
      builder: (ctx, snapshot) {
        if (snapshot.data == null) return Text('Loading');
        final Holdings holdings = snapshot.data!;
        final fieldController = TextEditingController(
          text: NumberFormat('##0.##').format(initialInput(holdings).rounded),
        );
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              _field(fieldController),
              SizedBox(width: 15),
              _button(fieldController, ctx, holdings),
            ],
          ),
        );
      },
    );
  }

  OutlinedButton _button(
    TextEditingController input,
    BuildContext context,
    Holdings holdings,
  ) {
    return OutlinedButton(
      onPressed: () => transact(Dollars(double.parse(input.text)))
          .then((value) => context.read<UiRefresher>().refreshUi())
          .catchError((Object err) => _errorSnackbar(context, err)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(buttonText(holdings)),
      ),
    );
  }

  void _errorSnackbar(BuildContext ctx, Object error) =>
      ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(content: Text('$error'), duration: Duration(minutes: 1)));

  SizedBox _field(TextEditingController fieldController) {
    return SizedBox(
      width: 60,
      child: TextFormField(
        controller: fieldController,
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: '\$ Amount',
        ),
        textAlign: TextAlign.center,
        onChanged: null,
      ),
    );
  }
}

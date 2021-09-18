import 'package:crypto_trader/data/data_sources.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:crypto_trader/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpendButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      // TODO it reloads the info after spend but not after deposit.
      //  What's the difference between the two implementation-wise?
      children: [_depositRow(context), _spendRow(context)],
    );
  }

  Widget _depositRow(BuildContext context) {
    final textFieldController = TextEditingController(text: 50.toString());
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _amountField(textFieldController),
        SizedBox(width: 15),
        _depositButton(context, textFieldController),
      ],
    );
  }

  ElevatedButton _depositButton(
    BuildContext context,
    TextEditingController textFieldController,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.green),
      onPressed: () {
        Environment.trader
            .deposit(Dollars(double.parse(textFieldController.text)))
            .whenComplete(() => context.read<UiRefresher>().refreshUi());
      },
      child: _text(context, 'Deposit from Schwab'),
    );
  }

  SizedBox _amountField(TextEditingController textFieldController) {
    return SizedBox(
      width: 60,
      child: TextFormField(
        controller: textFieldController,
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: '\$ Amount',
        ),
        textAlign: TextAlign.center,
        onChanged: null,
      ),
    );
  }

  Widget _spendRow(BuildContext context) {
    return FutureBuilder<Holdings>(
      future: Environment.trader.getMyHoldings(),
      builder: (ctx, snapshot) {
        if (snapshot.data == null) return Text('Loading');
        final Holdings holdings = snapshot.data!;
        final currency = holdings.shortest.currency;
        final fieldController = TextEditingController(
            text: holdings.of(dollars).amt.toInt().toString());
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 30,
                child: TextFormField(controller: fieldController),
              ),
              SizedBox(width: 15),
              ElevatedButton(
                onPressed: () {
                  Environment.trader
                      .spend(Dollars(double.parse(fieldController.text)))
                      .whenComplete(
                          () => context.read<UiRefresher>().refreshUi());
                },
                child: _text(ctx, 'Buy ${currency.name}'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _text(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(text, style: Theme.of(context).textTheme.button),
    );
  }
}

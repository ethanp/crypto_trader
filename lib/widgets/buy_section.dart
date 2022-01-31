import 'package:flutter/material.dart';

class BuySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Row(children: [
        SizedBox(width: 50, child: TextFormField()),
        const SizedBox(width: 20),
        ElevatedButton(
          // TODO(feature): Deposit until cash equals buy amount, then
          //  buy the currently-selected currency.
          onPressed: () {},
          child: const Text('Buy'),
        ),
      ]),
    );
  }
}

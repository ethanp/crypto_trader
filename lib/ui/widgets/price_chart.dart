import 'package:crypto_trader/data/access/granularity.dart';
import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Line chart of price history of a [Currency].
class PriceChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<PortfolioState>();
    return EasyFutureBuilder<List<Candle>>(
        future: Environment.prices.candles(state.currency, state.granularity),
        builder: (List<Candle>? candles) => candles == null
            ? const CupertinoActivityIndicator()
            : Column(children: [_chartHeader(state), MyLineChart(candles)]));
  }

  Widget _chartHeader(PortfolioState state) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
      child: Row(children: [
        _currencyName(state),
        const Spacer(),
        _granularityDropdown(state),
      ]));

  Widget _currencyName(PortfolioState state) => SizedBox(
      width: 150,
      child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: MyText(state.currency.name,
              // This key is required so that the AnimatedSwitcher interprets
              // the child as "new" each time the currency changes.
              key: ValueKey<String>(state.currency.name),
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  color: Colors.lightBlueAccent[100]))));

  Widget _granularityDropdown(PortfolioState state) => SizedBox(
      width: 140,
      height: 45,
      child: DropdownButtonFormField<Granularity>(
          value: state.granularity,
          items: _dropdownItems(),
          enableFeedback: true,
          onChanged: (Granularity? newValue) => state.setGranularity(newValue!),
          decoration:
              InputDecoration(filled: true, fillColor: Colors.grey[800])));

  List<DropdownMenuItem<Granularity>> _dropdownItems() => Granularities.all
      .map((dropdownValue) => DropdownMenuItem(
          value: dropdownValue,
          child: Text(
            dropdownValue.toString(),
            style: const TextStyle(fontSize: 14),
          )))
      .toList();
}

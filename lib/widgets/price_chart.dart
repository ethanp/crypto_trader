import 'package:crypto_trader/data/access/granularity.dart';
import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Line chart of price history of a [Currency].
class PriceChart extends StatelessWidget {
  /// Line chart of price history of a [Currency].
  const PriceChart({required this.candles});

  /// Price data for the chart.
  final List<Candle> candles;

  @override
  Widget build(BuildContext context) {
    final state = context.read<PortfolioState>();
    return Column(children: [
      _chartHeader(state),
      ChartData(candles),
    ]);
  }

  Widget _chartHeader(PortfolioState state) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
        child: Row(children: [
          _currencyName(state),
          const Spacer(),
          _granularityDropdown(state),
        ]),
      );

  Widget _currencyName(PortfolioState state) => SizedBox(
        width: 150,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: MyText(
            state.currency.name,
            // This key is required so that the AnimatedSwitcher interprets
            // the child as "new" each time the currency changes.
            key: ValueKey<String>(state.currency.name),
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
              color: Colors.lightBlueAccent[100],
            ),
          ),
        ),
      );

  Widget _granularityDropdown(PortfolioState state) {
    return SizedBox(
      width: 140,
      height: 45,
      child: DropdownButtonFormField<Granularity>(
        value: state.granularity,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[800],
        ),
        enableFeedback: true,
        onChanged: (Granularity? newValue) => state.setGranularity(newValue!),
        items: [
          for (final dropdownValue in Granularities.all)
            DropdownMenuItem(
              value: dropdownValue,
              child: Text(
                dropdownValue.toString(),
                style: const TextStyle(fontSize: 14),
              ),
            )
        ],
      ),
    );
  }
}

class CurrentGranularity extends ChangeNotifier {
  var _granularity = Granularities.days;

  Granularity get granularity => _granularity;

  void setGranularity(Granularity granularity) {
    _granularity = granularity;
    notifyListeners();
  }
}

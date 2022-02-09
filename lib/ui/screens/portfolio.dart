import 'package:crypto_trader/data/access/granularity.dart';
import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Portfolio extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Flexible(
        child: Column(children: [
          _priceChart(context.watch<PortfolioState>()),
          const SizedBox(height: 12), // Separator.
          _currencyList(),
        ]),
      );

  Widget _priceChart(PortfolioState state) => Expanded(
      child: EasyFutureBuilder<List<Candle>>(
          future: Environment.prices.candles(state.currency, state.granularity),
          builder: (List<Candle>? candles) => candles == null
              ? const CupertinoActivityIndicator()
              : PriceChart(candles: candles)));

  // Using ListView instead would allow user scrolling, which would help if
  // there were more portfolio items.
  Widget _currencyList() =>
      Column(children: Currencies.crypto.map(_asListItem).toList());

  Widget _asListItem(Currency currency) => Padding(
      padding: const EdgeInsets.all(2),
      child: WithHoldings(builderWithContext: (context, holdings) {
        final state = context.read<PortfolioState>();
        return GestureDetector(
            onTap: () => state.setCurrency(currency),
            child: PortfolioListItem(
              holdings: holdings,
              currency: currency,
              isSelected: currency == state.currency,
            ));
      }));
}

class PortfolioState extends ChangeNotifier {
  var _currency = Currencies.bitcoin;
  var _granularity = Granularities.oneDay;

  Currency get currency => _currency;

  Granularity get granularity => _granularity;

  void setCurrency(Currency currency) {
    _currency = currency;
    notifyListeners();
  }

  void setGranularity(Granularity granularity) {
    _granularity = granularity;
    notifyListeners();
  }
}

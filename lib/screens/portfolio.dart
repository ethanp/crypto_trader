import 'package:crypto_trader/data/access/granularity.dart';
import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:crypto_trader/widgets/portfolio_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Portfolio extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => PortfolioState())],
      builder: (context, _) => Flexible(
            child: Column(children: [
              _chart(context.watch<PortfolioState>()),
              const SizedBox(height: 12),
              _currencyList(),
            ]),
          ));

  Widget _chart(PortfolioState state) => Expanded(
      child: EasyFutureBuilder<List<Candle>>(
          future: Environment.prices.candles(state.currency, state.granularity),
          builder: (List<Candle>? candles) => candles == null
              ? const CupertinoActivityIndicator()
              : PriceChart(candles: candles)));

  // Using ListView instead would allow user scrolling, which would help if
  // there were more portfolio items.
  Widget _currencyList() => Column(
      children: Currencies.allCryptoCurrencies.map(_asListItem).toList());

  Widget _asListItem(Currency currency) => Padding(
      padding: const EdgeInsets.all(2),
      child: WithHoldings(builderC: (context, holdings) {
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

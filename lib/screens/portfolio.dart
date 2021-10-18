import 'package:crypto_trader/data/access/granularity.dart';
import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:crypto_trader/widgets/portfolio_card.dart';
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
              const SizedBox(height: 5),
              _currencyCards(),
            ]),
          ));

  Widget _chart(PortfolioState state) => Expanded(
      child: EasyFutureBuilder<List<Candle>>(
          future: Environment.prices.candles(state.currency, state.granularity),
          builder: (List<Candle>? candles) => candles == null
              ? const CupertinoActivityIndicator()
              : PriceChart(candles: candles)));

  Widget _currencyCards() => Wrap(
      spacing: 6,
      children: Currencies.allCryptoCurrencies.map(_asPortfolioCard).toList());

  Widget _asPortfolioCard(Currency currency) => WithHoldings(
        builderC: (ctx, holdings) {
          final state = ctx.read<PortfolioState>();
          return GestureDetector(
            onTap: () {
              print('Tapped card ${currency.name}');
              state.setCurrency(currency);
            },
            child: PortfolioCard(
              holdings: holdings,
              currency: currency,
              isSelected: currency == state.currency,
            ),
          );
        },
      );
}

class PortfolioState extends ChangeNotifier {
  var _currency = Currencies.bitcoin;
  var _granularity = Granularity.days;

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

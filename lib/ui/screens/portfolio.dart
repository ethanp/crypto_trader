import 'package:crypto_trader/data/access/granularity.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Portfolio extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Column(children: Currencies.crypto.map(_asListItem).toList());

  // Using ListView instead would allow user scrolling, which would help if
  // there were more portfolio items.

  Widget _asListItem(Currency currency) => Padding(
      padding: const EdgeInsets.all(2),
      child: WithHoldings(builderWithContext: (context, holdings) {
        final state = context.watch<PortfolioState>();
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

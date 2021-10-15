import 'package:crypto_trader/import_facade/controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Enables one Widget to cause other Widgets to rebuild.
class UiRefresher extends ChangeNotifier {
  /// Whenever [refresh] is called, this registered widget will be refreshed.
  static void register(BuildContext context) => context.watch<UiRefresher>();

  /// Refreshes global [Holdings] and rebuilds all [register]ed Widgets.
  static Future<void> refresh(BuildContext c) async =>
      c.read<UiRefresher>()._refreshUi();

  Future<void> _refreshUi() async {
    print('Refreshing UI');
    await Environment.trader.forceRefreshHoldings();
    notifyListeners();
  }
}

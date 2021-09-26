import 'package:crypto_trader/import_facade/controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UiRefresher extends ChangeNotifier {
  static void register(BuildContext context) => context.watch<UiRefresher>();

  static Future<void> refresh(BuildContext c) async =>
      c.read<UiRefresher>()._refreshUi();

  Future<void> _refreshUi() async {
    print('Refreshing UI');
    await Environment.trader.forceRefreshHoldings();
    notifyListeners();
  }
}

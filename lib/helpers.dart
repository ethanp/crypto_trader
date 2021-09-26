import 'package:crypto_trader/data/controller/data_controller.dart';
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

extension Zipper<T> on List<T> {
  List<U> zipWithIndex<U>(U Function(T, int) func) =>
      List.generate(this.length, (idx) => func(this[idx], idx));
}

extension Sum on Iterable<int> {
  int get sum => reduce((c, i) => c + i);
}

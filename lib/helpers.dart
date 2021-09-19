import 'package:crypto_trader/data/data_sources.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UiRefresher extends ChangeNotifier {
  Future<void> refreshUi() async {
    print('Refreshing UI');
    await Environment.trader.forceRefreshHoldings();
    notifyListeners();
  }

  static void register(BuildContext context) => context.watch<UiRefresher>();
}

extension Zipper<T> on List<T> {
  List<U> zipWithIndex<U>(U Function(T, int) func) =>
      List.generate(this.length, (idx) => func(this[idx], idx));
}

extension Sum on Iterable<int> {
  int get sum => reduce((c, i) => c + i);
}

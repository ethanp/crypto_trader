import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UiRefresher extends ChangeNotifier {
  void refreshUi() => notifyListeners();

  static void register(BuildContext context) => context.watch<UiRefresher>();
}

extension Zipper<T> on List<T> {
  List<U> zipWithIndex<U>(U Function(T, int) func) {
    int idx = 0;
    return map((elem) => func(elem, idx++)).toList();
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UiRefresher extends ChangeNotifier {
  void refreshUi() => notifyListeners();

  static void register(BuildContext context) => context.watch<UiRefresher>();
}

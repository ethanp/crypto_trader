import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Notifier extends ChangeNotifier {
  void triggerUiRebuild() => notifyListeners();

  static void registerForManualUiRefreshes(BuildContext context) =>
      context.watch<Notifier>();
}

import 'package:crypto_trader/data/data_sources.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui.dart';

class AppDependencies extends StatelessWidget {
  const AppDependencies({
    required this.prices,
    required this.trader,
  });

  final Prices prices;
  final Trader trader;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MyApp(),
      providers: [
        ChangeNotifierProvider(create: (_) => prices),
        ChangeNotifierProvider(create: (_) => trader),
      ],
    );
  }
}

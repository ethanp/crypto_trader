import 'package:crypto_trader/widgets/data/data_sources.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui.dart';

class AppDependencies extends StatelessWidget {
  const AppDependencies({required this.prices});

  final Prices prices;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MyApp(),
      providers: [
        ChangeNotifierProvider(create: (_) => prices),
      ],
    );
  }
}

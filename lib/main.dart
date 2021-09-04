import 'package:crypto_trader/widgets/app_dependencies.dart';
import 'package:flutter/material.dart';

import 'widgets/data/data_sources.dart';

void main() {
  runApp(AppDependencies(
    prices: Prices.coinbasePro(),
  ));
}

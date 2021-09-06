import 'package:crypto_trader/widgets/ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'helpers.dart';

void main() => runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => Notifier())],
    child: MyApp()));

import 'package:crypto_trader/widgets/app_config/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'helpers.dart';

void main() => runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => UiRefresher())],
    child: AppTheme()));

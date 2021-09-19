import 'package:crypto_trader/widgets/top_level/home_page.dart';
import 'package:flutter/material.dart';

import 'app_dependencies.dart';
import 'app_theme.dart';
import 'enable_keyboard_hiding.dart';

class WholeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppDependencies(
      child: EnableKeyboardHiding(
        child: MaterialApp(
          title: 'Crypto Trader',
          theme: AppTheme.std,
          home: HomePage(),
        ),
      ),
    );
  }
}

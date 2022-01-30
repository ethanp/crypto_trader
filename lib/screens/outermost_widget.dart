import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/ui_refresher.dart';
import 'package:crypto_trader/import_facade/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'body.dart';

/// The [Widget] created by [main()::runApp()].
class OutermostWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Only allow portrait orientation.
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // Print which environment is active
    print('Using ${Environment.fake ? 'FAKE' : 'REAL'} Coinbase API');

    // Seems like the top-level widget must create the outer MaterialApp().
    Widget materialApp = MaterialApp(
      theme: ThemeData.dark().copyWith(
        cardColor: Colors.grey[900],
      ),
      title: 'Crypto Trader',
      home: Body(),
    );

    // Enable keyboard hiding.
    materialApp = GestureDetector(
      // Source: https://stackoverflow.com/a/62327156/1959155
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: materialApp,
    );

    final providers = [
      ChangeNotifierProvider(create: (_) => UiRefresher()),
      ChangeNotifierProvider(create: (_) => MultistageCommandExecutor()),
    ];

    return MultiProvider(providers: providers, child: materialApp);
  }
}

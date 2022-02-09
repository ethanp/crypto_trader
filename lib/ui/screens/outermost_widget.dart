import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/ui.dart';
import 'package:crypto_trader/import_facade/util.dart';
import 'package:crypto_trader/ui/util/ui_refresher.dart';
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

    // I think we must create MaterialApp() *as an ancestor* of any widget that
    // will need to access MediaQuery.of(context).
    // Ref: https://stackoverflow.com/questions/48498709.
    Widget materialApp = MaterialApp(
      theme: ThemeData.dark(),
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
      ChangeNotifierProvider(create: (_) => PortfolioState()),
    ];

    return MultiProvider(providers: providers, child: materialApp);
  }
}

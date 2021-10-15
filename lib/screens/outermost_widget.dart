import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/ui_refresher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'body.dart';

/// The widget created by [main()].
class OutermostWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _alwaysRenderInPortraitOrientation();
    _printWhichEnvironmentIsActive();
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UiRefresher())],
      child: _enableKeyboardHiding(
        child: MaterialApp(
          theme: ThemeData.dark(),
          title: 'Crypto Trader',
          home: Body(),
        ),
      ),
    );
  }

  void _printWhichEnvironmentIsActive() =>
      print('Using ${Environment.fake ? 'FAKE' : 'REAL'} Coinbase API');

  void _alwaysRenderInPortraitOrientation() =>
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  /// Hide the keyboard on global tap.
  Widget _enableKeyboardHiding({required Widget child}) {
    return GestureDetector(
      /// Source: https://stackoverflow.com/a/62327156/1959155
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: child,
    );
  }
}

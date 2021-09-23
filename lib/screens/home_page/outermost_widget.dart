import 'package:crypto_trader/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/body.dart';

class OutermostWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UiRefresher())],
      child: _enableKeyboardHiding(
        child: MaterialApp(
          title: 'Crypto Trader',
          theme: standardTheme,
          home: Body(),
        ),
      ),
    );
  }

  Widget _enableKeyboardHiding({required Widget child}) {
    return GestureDetector(
      /// Hide the keyboard on global tap.
      ///
      /// Sources:
      ///   • https://flutterigniter.com/dismiss-keyboard-form-lose-focus/
      ///   • https://stackoverflow.com/a/62327156/1959155
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: child,
    );
  }

  static ThemeData get standardTheme => ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          button: TextStyle(color: Colors.white, fontSize: 20),
          headline4: TextStyle(
            color: Colors.grey[100],
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          headline3: TextStyle(
            color: Colors.green[200],
            fontSize: 26,
          ),
        ),
      );
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../home_page.dart';
import 'enable_keyboard_hiding.dart';

class AppTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EnableKeyboardHiding(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: _appTheme(),
        home: HomePage(),
      ),
    );
  }

  ThemeData _appTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      textTheme: TextTheme(
        button: TextStyle(color: Colors.white, fontSize: 20),
        headline4: TextStyle(
          color: Colors.grey[900],
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        headline3: TextStyle(
          color: Colors.green[700],
          fontSize: 26,
        ),
      ),
    );
  }
}

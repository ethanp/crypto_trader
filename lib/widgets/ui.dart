import 'package:flutter/material.dart';

import 'home_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: _appTheme(),
      home: HomePage(),
    );
  }

  ThemeData _appTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      textTheme: TextTheme(
        button: TextStyle(color: Colors.white, fontSize: 20),
        headline4: TextStyle(color: Colors.grey[900], fontSize: 24),
        headline3: TextStyle(color: Colors.green[700], fontSize: 28),
      ),
    );
  }
}

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
        headline3: TextStyle(
          color: Colors.green[700],
        ),
      ),
    );
  }
}

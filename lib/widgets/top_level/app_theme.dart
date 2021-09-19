import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get std => ThemeData(
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

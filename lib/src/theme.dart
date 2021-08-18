import 'package:flutter/material.dart';

var lightThemeData = new ThemeData(
    primaryColor: Color(0xff2e3092),
    toggleableActiveColor: Colors.blue,
    textTheme: new TextTheme(
      bodyText1: TextStyle(fontSize: 14.0, color: Color(0xff409cd0)),
      bodyText2: TextStyle(fontSize: 14.0, color: Color(0xff409cd0)),
      button: TextStyle(fontSize: 14.0, color: Color(0xff409cd0)),
      subtitle1: TextStyle(fontSize: 16.0, color: Color(0xff409cd0)),
      subtitle2: TextStyle(fontSize: 16.0, color: Color(0xff409cd0)),
      caption: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w300,
          color: Color(0xff409cd0)),
    ),
    brightness: Brightness.light,
    accentColor: Color(0xff83bae5));

var darkThemeData = ThemeData(
    primaryColor: Colors.blue,
    toggleableActiveColor: Colors.black,
    textTheme: new TextTheme(button: TextStyle(color: Colors.black54)),
    brightness: Brightness.light,
    accentColor: Colors.blue);

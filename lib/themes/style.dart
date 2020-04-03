import 'package:flutter/material.dart';

final Widget appLogo = ClipRRect(
  borderRadius: BorderRadius.circular(25.0),
  child: Image.asset(
    'assets/c3eastside_logo.jpg',
    height: 32,
  ),
);

final ThemeData themeData = ThemeData(
  brightness: Brightness.light,
  primaryColor: Color(0xFF232F34),
  bottomAppBarColor: Color(0xFF344955),
  accentColor: Color(0xFFF9AA33),
  backgroundColor: Color(0xFFefefef),
  cardColor: Colors.white,
  iconTheme: IconThemeData(color: Color(0xFF232F34)),
  fontFamily: 'WorkSansSubtitle',
  textTheme: TextTheme(
    headline5: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w100,
        fontFamily: 'WorkSansHeadline'),
    headline6: TextStyle(
        color: Color(0xFF232F34),
        fontWeight: FontWeight.w600,
        fontSize: 26.0,
        fontFamily: 'WorkSansTitle'),
    subtitle2:
        TextStyle(color: Color(0xFF4A6572), fontFamily: 'WorkSansSubtitle'),
  ),
);

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:scoped_model/scoped_model.dart';

import './navigation.dart';
import './secondary-pages/services.dart';
import './scoped-model/main.dart';
import './main-pages/settings.dart';
import './main-pages/location.dart';

void main() => runApp(ChurchApp());

class ChurchApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChurchAppState();
  }
}

class _ChurchAppState extends State<ChurchApp> {
  // MAIN THEME DATA
  ThemeData _theme = ThemeData(
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

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: MainModel(),
      child: MaterialApp(
        title: 'C3 CHURCH',
        theme: _theme,
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => Navigation(),
          'service': (BuildContext context) => ServicesPage(),
          'settings': (BuildContext context) => SettingsPage(),
          'location': (BuildContext context) => LocationPage()
        },
        onGenerateRoute: (RouteSettings settings) {
          return CupertinoPageRoute<bool>(
              builder: (BuildContext context) => Navigation());
        },
        // Fallback route if unable to find correct route (Will go to main page)
        onUnknownRoute: (RouteSettings settings) {
          return CupertinoPageRoute<void>(
              builder: (BuildContext context) => Navigation());
        },
      ),
    );
  }
}

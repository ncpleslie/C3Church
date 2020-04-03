import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:scoped_model/scoped_model.dart';

import './navigation.dart';
import './secondary-pages/services.dart';
import './scoped-model/main.dart';
import './main-pages/settings.dart';
import './main-pages/location.dart';
import './themes/style.dart';
import './globals/app_data.dart';

void main() => runApp(ChurchApp());

class ChurchApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChurchAppState();
  }
}

class _ChurchAppState extends State<ChurchApp> {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: ScopedModel<MainModel>(
        model: MainModel(),
        child: MaterialApp(
          title: APP_NAME,
          theme: themeData,
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
      ),
    );
  }
}

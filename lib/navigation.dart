import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';

import './main-pages/calendar.dart';
import './main-pages/location.dart';
import './main-pages/home.dart';
import './main-pages/media.dart';
import './scoped-model/main.dart';
import './globals/app_data.dart';

class Navigation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NavigationState();
  }
}

class _NavigationState extends State<Navigation> with TickerProviderStateMixin {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        model.context = context;
        return Scaffold(
          body: _getPage(model),
          bottomNavigationBar: _createBottomNavBar(),
        );
      },
    );
  }

  Widget _getPage(model) {
    // Stack and offstage used to ensure pages load correctly and don't reload of page change
    return Stack(
      children: <Offstage>[
        Offstage(
          offstage: _currentIndex != 0,
          child: TickerMode(enabled: _currentIndex == 0, child: HomePage()),
        ),
        Offstage(
          offstage: _currentIndex != 1,
          child: TickerMode(enabled: _currentIndex == 1, child: CalendarPage()),
        ),
        Offstage(
          offstage: _currentIndex != 2,
          child: TickerMode(enabled: _currentIndex == 2, child: MediaPage()),
        ),
        Offstage(
          offstage: _currentIndex != 3,
          child: TickerMode(enabled: _currentIndex == 3, child: LocationPage()),
        ),
      ],
    );
  }

  Widget _createBottomNavBar() {
    return FancyBottomNavigation(
      circleColor: Theme.of(context).accentColor,
      barBackgroundColor: Theme.of(context).primaryColor,
      inactiveIconColor: Theme.of(context).cardColor,
      activeIconColor: Theme.of(context).primaryColor,
      textColor: Theme.of(context).cardColor,
      tabs: <TabData>[
        TabData(iconData: Icons.home, title: APP_NAME),
        TabData(iconData: MdiIcons.calendarMultiselect, title: PAGE_TWO),
        TabData(iconData: Icons.play_circle_outline, title: PAGE_THREE),
        TabData(iconData: Icons.location_on, title: PAGE_FOUR),
      ],
      onTabChangedListener: (int position) {
        setState(() {
          _currentIndex = position;
        });
      },
    );
  }
}

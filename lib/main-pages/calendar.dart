import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/calendar_events.dart';
import '../scoped-model/main.dart';
import '../widgets/facebook_login_button.dart';
import '../widgets/future_list_view.dart';

class CalendarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalendarPageState();
  }
}

class _CalendarPageState extends State<CalendarPage> {
  MainModel _model;
  bool _loggedIn = false;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        _model = model;
        _checkLoggedInState();
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: SafeArea(
            top: true,
            child: _loggedIn
                ? FutureListView(
                    onLoad: _model.getEvents,
                    onUpdate: _model.updateEvents,
                    listView: _buildListView,
                    type: 'events')
                : FacebookLoginButton(),
          ),
        );
      },
    );
  }

  Widget _buildListView(List<dynamic> events) {
    return LiquidPullToRefresh(
      showChildOpacityTransition: false,
      onRefresh: _model.updateEvents,
      child: ListView.builder(
        itemCount: events != null ? events.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return CalendarEvents(events[index], _model);
        },
      ),
    );
  }

  void _checkLoggedInState() {
    _model.isLoggedIn.listen(
      (data) {
        if (data != _loggedIn && mounted) {
          setState(
            () {
              _loggedIn = data;
            },
          );
        }
      },
    );
  }
}

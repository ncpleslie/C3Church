import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/calendar_events.dart';
import '../models/calendar_events.dart';
import '../scoped-model/main.dart';
import '../widgets/nothing_loaded_card.dart';

class CalendarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalendarPageState();
  }
}

class _CalendarPageState extends State<CalendarPage> {
  final GlobalKey<ScaffoldState> _calendarScaffoldKey =
      GlobalKey<ScaffoldState>();
  List<CalendarEvent> _calendarEvents;
  MainModel _model;
  Future _calendarFuture;

  @override
  void initState() {
    // _loadingTimeOut();
    super.initState();
    _model = ScopedModel.of(context);
    _calendarFuture = _model.getCalendarEvents();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        _model = model;
        return Scaffold(
          key: _calendarScaffoldKey,
          backgroundColor: Theme.of(context).backgroundColor,
          body: SafeArea(top: true, child: _buildFutureListView(context)),
        );
      },
    );
  }

  Widget _buildFutureListView(BuildContext context) {
    return FutureBuilder<List<CalendarEvent>>(
      future: _calendarFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          _calendarEvents = snapshot.data;
          if (_calendarEvents == null || _calendarEvents.length == 0) {
            return NothingLoadedCard(
                title: "No Events",
                subtitle: "It seems like there are no upcoming events",
                callback: _refresh);
          }
          return _buildListView();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else
          return Center(child: CircularProgressIndicator());
      },
    );
  }

  void _refresh() {
    print("Refreshing");
  }

  ListView _buildListView() {
    return ListView.builder(
      itemCount: _calendarEvents != null ? _calendarEvents.length : 0,
      itemBuilder: (BuildContext context, int index) {
        return CalendarEvents(
            _calendarEvents[index], _calendarScaffoldKey, _model);
      },
    );
  }
}

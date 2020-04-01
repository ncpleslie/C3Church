import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/calendar_events.dart';
import '../models/calendar_events.dart';
import '../scoped-model/main.dart';

class CalendarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalendarPageState();
  }
}

class _CalendarPageState extends State<CalendarPage> {
  final GlobalKey<ScaffoldState> _calendarScaffoldKey =
      new GlobalKey<ScaffoldState>();
  bool error = false;

  @override
  void initState() {
    _loadingTimeOut();
    super.initState();
    MainModel _model = ScopedModel.of(context);
    _preloadData(_model);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _calendarScaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        top: true,
        child: _buildStreamBuilder(),
      ),
    );
  }

  Widget _buildStreamBuilder() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return StreamBuilder<List<CalendarEvent>>(
          stream: model.getEventsList,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              final content = snapshot.data
                  .map<Widget>((CalendarEvent data) =>
                      CalendarEvents(data, _calendarScaffoldKey, model))
                  .toList();
              return snapshot.data.isNotEmpty
                  ? ListView(children: content)
                  : _buildError(
                      model: model, errorString: 'No Events To Display');
            } else if (snapshot.hasError) {
              return _buildError(model: model, errorString: 'Error Loading...');
            } else if (!snapshot.hasData) {
              _preloadData(model);
              return Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }

  bool _loopPrevent = true;
  void _preloadData(MainModel model) async {
    if (_loopPrevent) {
      _loopPrevent = false;
      await model.getCalendarEvents();
    }
  }

  void _loadingTimeOut() {
    Future<void>.delayed(Duration(seconds: 5), () {
      error = true;
      if (this.mounted) {
        setState(() {});
      }
    });
  }

  Widget _buildError({MainModel model, String errorString}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            color: Colors.white,
            onPressed: () {
              if (mounted) {
                error = false;
                model.getCalendarEvents();
                if (this.mounted) {
                  setState(() {});
                  model.outsideLoading(true);
                }
              }
            },
          ),
          Text(
            errorString,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../models/calendar_events.dart';
import '../scoped-model/main.dart';

class CalendarEvents extends StatelessWidget {
  final MainModel model;
  final CalendarEvent data;
  final GlobalKey<ScaffoldState> _scaffoldKey;
  CalendarEvents(this.data, this._scaffoldKey, this.model);

  @override
  Widget build(BuildContext context) {
    return _buildListCalendarEvents(data);
  }

  Widget _buildListCalendarEvents(CalendarEvent data) {
    Map dates = _formatDate(data);
    return Card(
      elevation: 0,
      margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
      child: Container(
        decoration: BoxDecoration(color: Theme.of(model.context).cardColor),
        child: Stack(
          children: <Widget>[
            _addLeadingBlock(dates),
            _addExpandsionCalendarContent(dates)
          ],
        ),
      ),
    );
  }

  Widget _addLeadingBlock(dates) {
    return Container(
      width: 70,
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.symmetric(horizontal: 12.5, vertical: 12.5),
      color: Color(0xFFF9AA33),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            dates['day'],
            style: Theme.of(model.context).textTheme.headline6,
          ),
          Text(
            dates['month'],
            style: Theme.of(model.context).textTheme.subtitle2,
          ),
        ],
      ),
    );
  }

  Widget _addExpandsionCalendarContent(dates) {
    return ExpansionTile(
      title: Padding(
        padding: EdgeInsets.fromLTRB(60.0, 5.0, 0, 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AutoSizeText(
              data.eventTitle,
              maxLines: 1,
              style: Theme.of(model.context).textTheme.headline6,
            ),
            Text(
              '${dates['time']} ${dates['fullDate']}',
              style: Theme.of(model.context).textTheme.subtitle2,
            ),
          ],
        ),
      ),
      children: <Widget>[
        ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          title: Text(
            data.location,
            style: Theme.of(model.context).textTheme.headline6,
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(data.summary,
                style: Theme.of(model.context).textTheme.subtitle2),
          ),
          trailing: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(model.context).accentColor),
            child: IconButton(
              icon: Icon(
                MdiIcons.calendarPlus,
                size: 30.0,
                color: Theme.of(model.context).primaryColor,
              ),
              onPressed: () => _addEventToDeviceCalendar(),
            ),
          ),
        ),
      ],
    );
  }

  Map _formatDate(CalendarEvent data) {
    Map<String, String> returningMap;

    final DateFormat formatterDay = DateFormat.d();
    final String day = formatterDay.format(data.startTime).toString();
    final DateFormat formatterMonth = DateFormat('MMM');
    final String month = formatterMonth.format(data.startTime).toString();
    final DateFormat formatterFullDate = DateFormat('d/M/y');
    final String fullDate = formatterFullDate.format(data.startTime);
    final DateFormat formatterTime = DateFormat('h:mm a');
    final String time = formatterTime.format(data.startTime);
    returningMap = {
      'day': day,
      'month': month,
      'fullDate': fullDate,
      'time': time
    };
    return returningMap;
  }

  _addEventToDeviceCalendar() {
    final Event event = Event(
      title: data.eventTitle,
      description: data.summary,
      location: data.location,
      startDate: data.startTime,
      endDate: data.endTime,
    );
    Add2Calendar.addEvent2Cal(event).then((success) {
      Future.delayed(Duration(seconds: 1), () => _displaySuccessPopup(success));
    });
  }

  _displaySuccessPopup(success) {
    return _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Successfully Added Event'),
      duration: Duration(seconds: 2),
    ));
  }
}

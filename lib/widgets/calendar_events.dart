import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:overlay_support/overlay_support.dart';

import '../models/calendar_events.dart';
import '../scoped-model/main.dart';
import '../widgets/notification_card.dart';

class CalendarEvents extends StatefulWidget {
  final MainModel model;
  final CalendarEvent data;
  CalendarEvents(this.data, this.model);
  @override
  State<StatefulWidget> createState() {
    return _CalendarEventsState(data, model);
  }
}

class _CalendarEventsState extends State<CalendarEvents> {
  final MainModel model;
  final CalendarEvent data;
  _CalendarEventsState(this.data, this.model);

  @override
  Widget build(BuildContext context) {
    return _buildListCalendarEvents(context, data);
  }

  Widget _buildListCalendarEvents(BuildContext context, CalendarEvent data) {
    Map dates = _formatDate(data);
    return Card(
      elevation: 0,
      margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
      child: Container(
        decoration: BoxDecoration(color: Theme.of(model.context).cardColor),
        child: Stack(
          children: <Widget>[
            _addLeadingBlock(context, dates),
            _addExpandsionCalendarContent(dates)
          ],
        ),
      ),
    );
  }

  Widget _addLeadingBlock(BuildContext context, dates) {
    return Container(
      width: 70,
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.symmetric(horizontal: 12.5, vertical: 12.5),
      color: Theme.of(context).accentColor,
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

  bool _open = false;

  Widget _addExpandsionCalendarContent(dates) {
    return ExpansionTile(
      onExpansionChanged: ((status) => {
            setState(() {
              _open = status;
            })
          }),
      title: Padding(
        padding: EdgeInsets.fromLTRB(70.0, 5.0, 0, 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              data.eventTitle,
              maxLines: _open ? 4 : 1,
              style: Theme.of(model.context).textTheme.headline4,
              overflow: TextOverflow.ellipsis,
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
          title: Padding(
            padding: EdgeInsets.fromLTRB(70.0, 10.0, 0, 0.0),
            child: Text(
              'Location: ${data.location}',
              style: Theme.of(model.context).textTheme.subtitle2,
            ),
          ),
          subtitle: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(70.0, 10.0, 0, 0.0),
                child: Text(data.summary,
                    style: Theme.of(model.context).textTheme.subtitle2),
              ),
              _addEventButton()
            ],
          ),
        ),
      ],
    );
  }

  Widget _addEventButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(model.context).size.height / 15,
        child: RaisedButton.icon(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(0.0),
          )),
          label: Text("Add Event To Calendar"),
          elevation: 0,
          color: Theme.of(model.context).accentColor,
          icon: Icon(
            MdiIcons.calendarPlus,
            color: Theme.of(model.context).primaryColor,
          ),
          onPressed: () => _addEventToDeviceCalendar(),
        ),
      ),
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

  _addEventToDeviceCalendar() async {
    final Event event = Event(
      title: data.eventTitle,
      description: data.summary,
      location: data.location,
      startDate: data.startTime,
      endDate: data.endTime,
    );
    if (await Add2Calendar.addEvent2Cal(event)) {
      Future.delayed(
          Duration(seconds: 1), () => _showInAppNotification(true, 5000));
    } else {
      Future.delayed(
          Duration(seconds: 1), () => _showInAppNotification(false, 5000));
    }
  }

  void _showInAppNotification(bool success, int length) {
    showOverlayNotification((context) {
      return NotificationCard(
        context: context,
        title: "Adding event to Calendar",
        message: success ? "Successfully added event" : "Failed to add event",
        callback: OverlaySupportEntry.of(context).dismiss,
      );
    }, duration: Duration(milliseconds: length));
  }
}

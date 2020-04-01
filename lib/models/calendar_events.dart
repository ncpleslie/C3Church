import 'package:flutter/material.dart';

class CalendarEvent {
  CalendarEvent({@required this.eventTitle, @required this.startTime, @required this.endTime, @required this.summary, this.location});

  final String eventTitle;
  final DateTime startTime;
  final DateTime endTime;
  final String summary;
  final String location;
}
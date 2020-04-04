import 'package:timezone/standalone.dart';
// Calendar events are used in the calendar tab
// Events are pulled from Google Calendar API

class CalendarEvent {
  CalendarEvent(
      {this.eventTitle,
      this.startTime,
      this.endTime,
      this.summary,
      this.location});

  final String eventTitle;
  final DateTime startTime;
  final DateTime endTime;
  final String summary;
  final String location;

  factory CalendarEvent.fromJson(Map<String, dynamic> json, Location location) {
    final String eventTitle =
        json['name'] != null ? json['name'] : "Title Missing";
    final DateTime startTime = json['start_time'] != null
        ? TZDateTime.from(DateTime.parse(json['start_time']), location)
        : DateTime.now();
    final DateTime endTime = json['end_time'] != null
        ? TZDateTime.from(DateTime.parse(json['end_time']), location)
        : DateTime.now();
    final String summary =
        json['description'] != null ? json['description'] : "";
    final String locationOfEvent = json['place']['name'] != null
        ? json['place']['name']
        : "Location Missing";

    return CalendarEvent(
        eventTitle: eventTitle,
        startTime: startTime,
        endTime: endTime,
        summary: summary,
        location: locationOfEvent);
  }
}

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
}

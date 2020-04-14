import 'dart:convert';
import 'package:http/http.dart' as http;

import './connected_model.dart';
import '../models/calendar_events.dart';
import '../globals/app_data.dart';

mixin CalendarModel on ConnectedModel {
  int maxResults = 30;
  String orderBy = 'startTime';
  Future _calendarFuture;
  final String _eventUrl = FACEBOOK_EVENT_URL + "&access_token=";

  Future getEvents() {
    if (_calendarFuture == null) {
      _calendarFuture = _getEvents();
    }
    return _calendarFuture;
  }

  Future<List<dynamic>> _getEvents() async {
    print('Fetching Calendar Events');
    startFunction();
    // Set Timezone to NZ (only location this app will work)
    await loadDefaultData().then((rawData) => initialiseLocation(rawData));
    final http.Response response = await fetch(_eventUrl + token);
    Iterable json = jsonDecode(response.body)['events']['data'];
    endFunction();
    return json
        .map((event) => CalendarEvent.fromJson(event, location))
        .toList();
  }

  Future updateEvents() {
    _calendarFuture = _getEvents();
    return _calendarFuture;
  }
}

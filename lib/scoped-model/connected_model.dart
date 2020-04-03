import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import 'package:rxdart/rxdart.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:timezone/standalone.dart';
import 'package:timezone/src/env.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';

import '../models/calendar_events.dart';
import '../models/podcasts.dart';
import '../globals/globals.dart';
import '../globals/app_data.dart';

mixin ConnectedModel on Model {
  // Loading Relevant Stuff
  final _isLoading = BehaviorSubject<bool>(seedValue: false);
  Stream<bool> get isLoading => _isLoading.stream;

  void outsideLoading(bool loading) {
    _isLoading.add(loading);
    notifyListeners();
  }

  void _startFunction() {
    _isLoading.add(true);
    notifyListeners();
  }

  void _endFunction() {
    _isLoading.add(false);
    notifyListeners();
  }

  BuildContext context;
}

// --------------------------------------------------------------------- //
mixin PodcastModel on ConnectedModel {
  final String _podcastURL = PODCAST;
  int maxNum = 10;
  Future<List<Podcast>> getPodcasts() async {
    print('Fetching Podcasts');
    _startFunction();
    final http.Response response = await _fetchPodcasts();
    final json = _convertXMLtoJSON(response.body);
    Iterable list = json['rss']['channel']['item'];
    _endFunction();
    return list
        .map((podcast) => Podcast.fromJson(podcast))
        .take(maxNum)
        .toList();
  }

  Future<http.Response> _fetchPodcasts() async {
    _isLoading.add(true);
    notifyListeners();
    final String url = _podcastURL;
    final http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception("Failed to load podcasts");
    }
  }

  dynamic _convertXMLtoJSON(String body) {
    final Xml2Json xml2json = Xml2Json();
    xml2json.parse(body);
    final String jsonData = xml2json.toBadgerfish();
    return jsonDecode(jsonData);
  }
}

// --------------------------------------------------------------------- //
mixin CalendarModel on ConnectedModel {
  final _scopes = const [CalendarApi.CalendarEventsReadonlyScope];
  Location _location;
  String pageToken;
  int maxResults = 30;
  String orderBy = 'startTime';

  Future<List<CalendarEvent>> getCalendarEvents() async {
    print('Fetching Calendar Events');
    _startFunction();
    final calendarEvents = await _fetchCalenderEvents();
    _endFunction();
    return _convertCalendarEvents(calendarEvents);
  }

  Future<Events> _fetchCalenderEvents() async {
    Future<Events> events;
    // Set Timezone to NZ (only location this app will work)
    await loadDefaultData().then((rawData) => _getLocation(rawData));
    // Fetch Calendar Data
    await clientViaServiceAccount(credentials, _scopes).then((client) {
      CalendarApi calendar = CalendarApi(client);
      events = calendar.events.list(CALENDAR_EMAIL_ADDRESS,
          orderBy: orderBy,
          singleEvents: true,
          maxResults: maxResults,
          pageToken: pageToken);
    });
    return events;
  }

  List<CalendarEvent> _convertCalendarEvents(Events event) {
    CalendarEvent calendarEvents;
    List<CalendarEvent> _fetchedEvents = <CalendarEvent>[];
    pageToken = event.nextPageToken;
    for (Event event in event.items) {
      calendarEvents = CalendarEvent(
          eventTitle: event.summary,
          startTime: TZDateTime.from(event.start.dateTime, _location),
          endTime: TZDateTime.from(event.end.dateTime, _location),
          summary: event.description,
          location: event.location);
      _fetchedEvents.add(calendarEvents);
    }
    return _fetchedEvents;
  }

// Time Zone setting (New Zealand)
  Future<List<int>> loadDefaultData() async {
    var byteData = await rootBundle.load('assets/2018i_2010-2020.tzf');
    return byteData.buffer.asUint8List();
  }

  _getLocation(List<int> rawData) {
    initializeDatabase(rawData);
    _location = getLocation('Pacific/Auckland');
  }
}

// --------------------------------------------------------------------- //
mixin UrlLauncher on ConnectedModel {
  loadMaps(BuildContext context) async {
    String mapUrl = GOOGLE_MAP_URL;
    String appleUrl = APPLE_MAP_URL;
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      mapUrl = appleUrl;
    }
    _launch(mapUrl);
  }

  call() async {
    final String tel = 'tel:' + PHONE_NUMBER;
    _launch(tel);
  }

  email() async {
    final String email = 'mailto:' + EMAIL;
    _launch(email);
  }

  website({String website = WEBSITE}) async {
    _launch(website);
  }

  _launch(String link) async {
    if (await canLaunch(link)) {
      launch(link);
    } else {
      throw 'Error launching';
    }
  }
}

// --------------------------------------------------------------------- //
mixin Notifications on ConnectedModel {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future initialiseNotifications(
      Function activateInAppCallback, Function activateOutAppCallback) async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      // Called when the app is open and notification recieved
      onMessage: (Map<String, dynamic> message) async {
        String notificationTitle = message['notification']['title'] != null
            ? message['notification']['title']
            : "Error loading notification title";
        String notificationBody = message['notification']['body'] != null
            ? message['notification']['body']
            : "Error loading notification message";
        String newPage = message['data']['type'] != null
            ? message['data']['type']
            : "noPage";
        int notificationLength = message['data']['length'] != null
            ? int.tryParse(message['data']['length']) * 1000 ?? 5000
            : 5000;
        activateInAppCallback(
            notificationTitle, notificationBody, newPage, notificationLength);
      },
      // Called when the app not in memory/not running and is opened with the notification
      onLaunch: (Map<String, dynamic> message) async {
        String newPage =
            message['data']['type'] != null ? message['data']['type'] : null;
        activateOutAppCallback(newPage);
      },
      // Called when the app is open, via notification, when running in background
      onResume: (Map<String, dynamic> message) async {
        String newPage =
            message['data']['type'] != null ? message['data']['type'] : null;
        activateOutAppCallback(newPage);
      },
    );
  }
}

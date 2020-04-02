import 'dart:async';
import 'dart:convert';

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
import 'package:onesignalflutter/onesignalflutter.dart';

import '../models/calendar_events.dart';
import '../models/podcasts.dart';
import '../globals/globals.dart';

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
  final String _podcastURL = 'https://c3churchchch.podbean.com/feed.xml';
  int maxNum = 10;
  Future<List<Podcast>> getPodcasts() async {
    print('Fetching Podcasts');
    _startFunction();
    final xmlOfPodcasts = await _fetchPodcasts();
    final json = _convertXMLtoJSON(xmlOfPodcasts);
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

  dynamic _convertXMLtoJSON(http.Response response) {
    final Xml2Json xml2json = Xml2Json();
    xml2json.parse(response.body);
    final String jsonData = xml2json.toParker();
    return json.decode(jsonData);
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
    final double lat = -43.5029809;
    final double lon = 172.649236;
    String mapUrl = 'https://goo.gl/maps/YdgaWWT8NCo';
    String appleUrl = 'https://maps.apple.com/?sll=$lat,$lon';
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      mapUrl = appleUrl;
    }
    if (await canLaunch(mapUrl)) {
      print('launching $mapUrl');
      await launch(mapUrl);
    } else {
      throw 'Could not launch maps';
    }
  }

  call() async {
    final String tel = 'tel:+6433850170';
    if (await canLaunch(tel)) {
      launch(tel);
    } else {
      throw 'Error loading phone';
    }
  }

  email() async {
    final String email = 'mailto:office@c3chch.org';
    if (await canLaunch(email)) {
      launch(email);
    } else {
      throw 'Error loading email';
    }
  }

  website() async {
    final String website = 'http://c3chch.org';
    if (await canLaunch(website)) {
      launch(website);
    } else {
      throw 'Error loading website';
    }
  }
}

// --------------------------------------------------------------------- //
mixin Notifications on ConnectedModel {
  // CHANGE THIS parameter to true if you want to test GDPR privacy consent
  bool _requireConsent = true;
  var settings = {
    OSiOSSettings.autoPrompt: false,
    OSiOSSettings.promptBeforeOpeningPushUrl: true
  };
  initNotifications() {
    OneSignal.shared.setRequiresUserPrivacyConsent(_requireConsent);
    OneSignal.shared.init(ONE_SIGNAL_APP_IP);
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);
  }

  bool _notificationsAllowed = true;

  bool get notificationStatus {
    return _notificationsAllowed;
  }

  toggleNotifications() {
    // TODO TIE TO BACK NOTIFICATION SYSTEM
    _notificationsAllowed
        ? _notificationsAllowed = false
        : _notificationsAllowed = true;
    notifyListeners();
    print(notificationStatus);
  }
}

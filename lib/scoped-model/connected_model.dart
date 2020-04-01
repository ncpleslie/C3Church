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

mixin PodcastModel on ConnectedModel {
  Stream<List> get getPodcastList => _listOfFormattedPodcasts.stream;
  final _listOfFormattedPodcasts = BehaviorSubject<List<Podcasts>>();

  List<Podcasts> _podcasts = <Podcasts>[];

  Future<Null> getPodcasts() async {
    print('Fetching Podcasts');
    _startFunction();
    final podcasts = await _fetchPodcasts();
    final List formattedPodcasts = await _convertPodcastData(podcasts);
    final podcastListObject = await _addPodcastsToObject(formattedPodcasts);
    _podcasts = podcastListObject;
    _listOfFormattedPodcasts.add(_podcasts);
    _endFunction();
  }

  _fetchPodcasts() async {
    _isLoading.add(true);
    notifyListeners();
    final String _url = 'https://c3churchchch.podbean.com/feed.xml';
    final http.Response response = await http.get(_url);
    if (response.statusCode == 200) {
      return response;
    }
  }

  _convertPodcastData(http.Response response) {
    final Xml2Json xml2json = Xml2Json();
    xml2json.parse(response.body);
    final String jsonData = xml2json.toParker();
    final List listOfPodcasts = json.decode(jsonData)['rss']['channel']['item'];
    return listOfPodcasts;
  }

  _getEastsidePodcasts(listOfPodcasts) {
    final List listOfEastsidePodcasts = [];
    for (int i = 0; i <= listOfPodcasts.length - 1; i++) {
      var podcastCheck =
          listOfPodcasts[i]['itunes:summary'].contains('EASTSIDE');
      if (podcastCheck) {
        listOfEastsidePodcasts.add(listOfPodcasts[i]);
      }
    }
    return listOfEastsidePodcasts;
  }

  _addPodcastsToObject(listOfEastsidePodcasts) {
    Podcasts podcasts;
    List<Podcasts> podcastList = [];
    int count = 0;
    int maxNumOfPodcasts = 10;
    for (var podcastData in listOfEastsidePodcasts) {
      if (count == maxNumOfPodcasts) break;
      count++;
      podcasts = Podcasts(
          title: podcastData['title'],
          date: podcastData['pubDate']
              .substring(0, podcastData['pubDate'].length - 15),
          summary: podcastData['itunes:summary'],
          link: podcastData['link']);
      podcastList.add(podcasts);
    }
    return podcastList;
  }
}

mixin CalendarModel on ConnectedModel {
  Stream<List<CalendarEvent>> get getEventsList => _listOfCalendarEvents.stream;
  final _listOfCalendarEvents = BehaviorSubject<List<CalendarEvent>>();

  List<CalendarEvent> _calendar = <CalendarEvent>[];

  final _scopes = const [CalendarApi.CalendarEventsReadonlyScope];
  Location newZealand;
  String pageToken;

  Future<Null> getCalendarEvents() async {
    print('Fetching Calendar Events');
    _startFunction();
    final calendarEvents = await initCalendarFetch();
    final allCalendarEvents = await _convertCalendarEvents(calendarEvents);
    _calendar = allCalendarEvents;
    _listOfCalendarEvents.add(_calendar);
    _endFunction();
  }

  Future<Events> initCalendarFetch() async {
    Future<Events> calEvents;
    // Set Timezone to NZ (only location this app will work)
    await loadDefaultData().then((rawData) => _getLocation(rawData));
    // Fetch Calendar Data
    await clientViaServiceAccount(credentials, _scopes).then((client) {
      CalendarApi calendar = CalendarApi(client);
      calEvents = calendar.events.list(calendarEmailAddress,
          orderBy: 'startTime',
          singleEvents: true,
          maxResults: 30,
          pageToken: pageToken);
    });
    return calEvents;
  }

  Future<List<CalendarEvent>> _convertCalendarEvents(Events calEvents) async {
    CalendarEvent calendarEvents;
    List<CalendarEvent> _fetchedEvents = <CalendarEvent>[];
    pageToken = calEvents.nextPageToken;
    for (Event event in calEvents.items) {
      calendarEvents = CalendarEvent(
          eventTitle: event.summary,
          startTime: TZDateTime.from(event.start.dateTime, newZealand),
          endTime: TZDateTime.from(event.end.dateTime, newZealand),
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

  _getLocation(rawData) {
    initializeDatabase(rawData);
    newZealand = getLocation('Pacific/Auckland');
  }
}

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

mixin Notifications on ConnectedModel {
  initNotifications() {
    OneSignal.shared.init(
      oneSignalAppId,
    );
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

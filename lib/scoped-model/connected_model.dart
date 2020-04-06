import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/standalone.dart';
import 'package:timezone/src/env.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/calendar_events.dart';
import '../models/podcasts.dart';
import '../models/posts.dart';
import '../globals/globals.dart';
import '../globals/app_data.dart';
import '../utils/utils.dart';

mixin ConnectedModel on Model {
  // Loading Relevant Stuff
  final _isLoading = BehaviorSubject<bool>(seedValue: false);
  Stream<bool> get isLoading => _isLoading.stream;
  FacebookAccessToken _accessToken;

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

  Future<http.Response> _fetch(String url) async {
    _isLoading.add(true);
    notifyListeners();
    final http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception("Failed to load data");
    }
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
    final http.Response response = await _fetch(_podcastURL);
    final json = _convertXMLtoJSON(response.body);
    Iterable list = json['rss']['channel']['item'];
    _endFunction();
    return list
        .map((podcast) => Podcast.fromJson(podcast))
        .take(maxNum)
        .toList();
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
  Location _location;
  String pageToken;
  int maxResults = 30;
  String orderBy = 'startTime';

  final String _eventUrl = FACEBOOK_EVENT_URL + "&access_token=";

  Future<List<dynamic>> getEvents() async {
    try {
      print('Fetching Calendar Events');
      _startFunction();
      // Set Timezone to NZ (only location this app will work)
      await loadDefaultData().then((rawData) => _getLocation(rawData));
      final http.Response response =
          await _fetch(_eventUrl + _accessToken.token);
      Iterable json = jsonDecode(response.body)['events']['data'];
      _endFunction();
      return json
          .map((event) => CalendarEvent.fromJson(event, _location))
          .toList();
    } catch (e, stack) {
      throw "There was an error: $e \n $stack";
    }
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
mixin PostModel on ConnectedModel {
  final String _postUrl = FACEBOOK_POST_URL + "&access_token=";

  Future<FacebookAccessToken> isLoggedIn() async {
    // Access device DB
    // Get access token
    final Future<Database> database =
        openDatabase(join(await getDatabasesPath(), 'user.db'));
  }

  Future<List<dynamic>> getPosts() async {
    print('Fetching Facebook Posts');
    _startFunction();
    final http.Response response = await _fetch(_postUrl + _accessToken.token);
    _endFunction();
    print(response.body);
    return jsonDecode(response.body)['posts']['data']
        .map((post) => Post.fromJson(post))
        .toList();
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
        String notificationTitle =
            isNullEmptyOrFalse(message['notification']['title'])
                ? message['notification']['title']
                : "Error loading notification title";
        String notificationBody =
            isNullEmptyOrFalse(message['notification']['body'])
                ? message['notification']['body']
                : "Error loading notification message";
        String newPage = isNullEmptyOrFalse(message['data']['type'])
            ? message['data']['type']
            : "noPage";
        int notificationLength = isNullEmptyOrFalse(message['data']['length'])
            ? int.tryParse(message['data']['length']) * 1000 ?? 5000
            : 5000;
        activateInAppCallback(
            notificationTitle, notificationBody, newPage, notificationLength);
      },
      // Called when the app not in memory/not running and is opened with the notification
      onLaunch: (Map<String, dynamic> message) async {
        String newPage = isNullEmptyOrFalse(message['data']['type'])
            ? message['data']['type']
            : null;
        activateOutAppCallback(newPage);
      },
      // Called when the app is open, via notification, when running in background
      onResume: (Map<String, dynamic> message) async {
        String newPage = isNullEmptyOrFalse(message['data']['type'])
            ? message['data']['type']
            : null;
        activateOutAppCallback(newPage);
      },
    );
  }
}

// --------------------------------------------------------------------- //
mixin Login on ConnectedModel {
  final facebookLogin = FacebookLogin();

  Future<bool> initialiseLogin() async {
    _startFunction();
    final result = await facebookLogin.logIn(['email']);

    bool logInStatus = false;
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        _accessToken = result.accessToken;
        print(_accessToken.token);
        logInStatus = true;
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("Cancelled");
        break;
      case FacebookLoginStatus.error:
        print(result.errorMessage);
        break;
    }
    _endFunction();
    return logInStatus;
  }
}

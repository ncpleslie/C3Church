import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:timezone/standalone.dart';
// The following package is needed to set timezone
import 'package:timezone/src/env.dart' as env; // ignore: implementation_imports
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/facebook_user.dart';
import '../globals/app_data.dart';
import '../utils/utils.dart';

mixin ConnectedModel on Model {
  // Loading Relevant Stuff
  final _isLoading = BehaviorSubject<bool>(seedValue: false);
  Stream<bool> get isLoading => _isLoading.stream;

  final _isLoggedIn = BehaviorSubject<bool>(seedValue: false);
  Stream<bool> get isLoggedIn => _isLoggedIn.stream;

  Location _location;

  FacebookUser _user;

  String get token {
    if (_user != null && _user.token != null) {
      if (_user.expiryDate != null &&
          _user.expiryDate.isAfter(DateTime.now()) &&
          _user.token != null) {
        _isLoggedIn.add(true);
        return _user.token;
      }
      _isLoggedIn.add(false);
      return null;
    }
    _isLoggedIn.add(false);
    return null;
  }

  void startFunction() {
    _isLoading.add(true);
    notifyListeners();
  }

  void endFunction() {
    _isLoading.add(false);
    notifyListeners();
  }

  Future<http.Response> fetch(String url) async {
    _isLoading.add(true);
    notifyListeners();
    final http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 403) {
      throw Exception(
          '${json.decode(response.body)['error']['message']}.\nThis shouldn\'t happen.\nTry restarting the application.');
    } else {
      throw Exception(
          "Failed to load data from external source.\nThis shouldn't happen.\nTry restarting the application.");
    }
  }

  BuildContext context;

  // Time Zone setting (New Zealand)
  Future<List<int>> loadDefaultData() async {
    var byteData = await rootBundle.load('assets/2018i_2010-2020.tzf');
    return byteData.buffer.asUint8List();
  }

  initialiseLocation(List<int> rawData) {
    env.initializeDatabase(rawData);
    _location = getLocation('Pacific/Auckland');
  }

  get location {
    return _location;
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
            !isNullEmptyOrFalse(message['notification']['title'])
                ? message['notification']['title']
                : "Error loading notification title";
        String notificationBody =
            !isNullEmptyOrFalse(message['notification']['body'])
                ? message['notification']['body']
                : "Error loading notification message";
        String newPage = !isNullEmptyOrFalse(message['data']['type'])
            ? message['data']['type']
            : "noPage";
        int notificationLength = !isNullEmptyOrFalse(message['data']['length'])
            ? int.tryParse(message['data']['length']) * 1000 ?? 5000
            : 5000;
        activateInAppCallback(
            notificationTitle, notificationBody, newPage, notificationLength);
      },
      // Called when the app not in memory/not running and is opened with the notification
      onLaunch: (Map<String, dynamic> message) async {
        String newPage = !isNullEmptyOrFalse(message['data']['type'])
            ? message['data']['type']
            : null;
        activateOutAppCallback(newPage);
      },
      // Called when the app is open, via notification, when running in background
      onResume: (Map<String, dynamic> message) async {
        String newPage = !isNullEmptyOrFalse(message['data']['type'])
            ? message['data']['type']
            : null;
        activateOutAppCallback(newPage);
      },
    );
  }
}

// --------------------------------------------------------------------- //
mixin Auth on ConnectedModel {
  final _auth = FacebookLogin();

  Future login() async {
    startFunction();
    if (await _auth.isLoggedIn) {
      _isLoggedIn.add(true);
      return;
    }

    try {
      final result = await _auth.logIn(['email']);
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          final bool isNonExpiringToken =
              result.accessToken.expires.millisecondsSinceEpoch == -1;

          _user = FacebookUser(
              userId: result.accessToken.userId,
              token: result.accessToken.token,
              expiryDate: isNonExpiringToken
                  ? DateTime.now().add(Duration(days: 60))
                  : result.accessToken.expires);
          _storePrefs();
          _isLoggedIn.add(true);
          break;
        case FacebookLoginStatus.cancelledByUser:
          print("Cancelled");
          break;
        case FacebookLoginStatus.error:
          print("Error found: ${result.errorMessage}");
          throw Exception(
              'An error occured during the login process\nHere\'s what Facebook gave us: ${result.errorMessage}');
          break;
      }
    } catch (error) {
      throw Exception(error);
    }
    endFunction();
  }

  Future<void> _storePrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userData', _user.toJson());
    } catch (error) {
      throw Exception("Failed storing user token");
    }
  }

  Future<void> logout() async {
    await _auth.logOut();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    _user = null;
    _isLoggedIn.add(false);
    endFunction();
  }

  Future<bool> tryAutoLogin() async {
    startFunction();
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      _isLoggedIn.add(false);
      return false;
    }
    final userData = prefs.getString('userData');
    _user = FacebookUser.fromJson(json.decode(userData) as Map<String, Object>);
    if (token == null) {
      _isLoggedIn.add(false);
      return false;
    }
    endFunction();
    _isLoggedIn.add(true);
    return true;
  }
}

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-model/main.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            elevation: 0,
            title: Text(
              'Settings',
              style: Theme.of(context).textTheme.headline6,
            ),
            centerTitle: true,
            iconTheme: Theme.of(context).iconTheme,
          ),
          backgroundColor: Theme.of(context).backgroundColor,
          body: ListView(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.notifications,
                  color: Theme.of(context).accentColor,
                ),
                title: Text(
                  'Toggle Notifications',
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: Text(
                  'Toggle whether you want notifications or not',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                trailing: Switch.adaptive(
                  value: model.notificationStatus,
                  onChanged: (_) => model.toggleNotifications(),
                  activeTrackColor: Theme.of(context).accentColor,
                  activeColor: Theme.of(context).accentColor,
                ),
              ),
              ListTile(
                leading: Icon(
                  MdiIcons.church,
                  color: Theme.of(context).accentColor,
                ),
                title: Text(
                  'Created For',
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: Text(
                  'C3 Church\nEastside, Christchurch\nNew Zealand',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.announcement,
                  color: Theme.of(context).accentColor,
                ),
                title: Text(
                  'Enquries',
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: Text(
                  'For enquries, please contact C3 Eastside (See contact page)',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.copyright,
                  color: Theme.of(context).accentColor,
                ),
                title: Text(
                  'More Infomation On This App',
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: Text(
                  'For more information on this app please contact the developer at ncpleslie.github.io',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.lock,
                  color: Theme.of(context).accentColor,
                ),
                title: Text(
                  'Privacy Policy',
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: Text(
                  'C3 Church Eastside and App Developer (NCPLeslie) do not collect personal information. No data is stored by us (C3 Eastside and App Developer). This app does/will make connections to external services for retrieval of relevant data (Podcasts (Podbean), Calendar Events (Google Calendar), Notifications (Google Firestore), Push Notifications (OneSignal)). These services may collect your data. Google, Podbean, and OneSignal have no connection with C3 Eastside or the App Developer.',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

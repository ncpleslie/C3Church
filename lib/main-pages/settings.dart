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
              'About',
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
                  Icons.lock,
                  color: Theme.of(context).accentColor,
                ),
                title: Text(
                  'Privacy Policy',
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: Text(
                  'C3 Church Eastside and the App Developer do not collect personal information. No data is stored by C3 Eastside or the App Developer. This app does/will make connections to external services for retrieval of relevant data. These services are, but not limited to, Google, OneSignal, and PodBean. C3 Eastside or the App Developer have no connection with these service providers.',
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

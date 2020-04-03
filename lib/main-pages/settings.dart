import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-model/main.dart';
import '../globals/app_data.dart';

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
                  CREATED_FOR,
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
                  PRIVACY_POLICY,
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

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-model/main.dart';
import '../globals/app_data.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  MainModel _model;
  bool _loggedIn = false;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        _model = model;
        _autoLoginProcess();
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
              // LOGOUT FUNCTION
              _loggedIn
                  ? ListTile(
                      leading: Icon(
                        MdiIcons.facebook,
                        color: Theme.of(context).accentColor,
                      ),
                      title: Text(
                        'Logout',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      subtitle: Text(
                        'Click here to remove Facebook access from this app.',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      trailing: InkWell(
                        onTap: _logout,
                        child: Icon(
                          MdiIcons.logout,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    )
                  : Container(),
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

  void _logout() {
    _model.logout();
    setState(() => _loggedIn = false);
  }

  void _autoLoginProcess() {
    _loggedIn = _model.isLoggedIn;
  }
}

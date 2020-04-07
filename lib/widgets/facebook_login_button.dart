import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FacebookLoginButton extends StatelessWidget {
  final Function login;
  FacebookLoginButton(this.login);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: login,
      child: ListTile(
        leading: Icon(
          MdiIcons.facebook,
          color: Theme.of(context).accentColor,
        ),
        title: Text(
          'Login with Facebook',
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          'Login with Facebook to see all the exciting posts and events happening at Eastside C3',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        trailing: Icon(
          MdiIcons.login,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}

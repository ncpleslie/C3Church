import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class FacebookLoginButton extends StatelessWidget {
  final Function login;
  FacebookLoginButton(this.login);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: login,
      child: ListTile(
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
        ),
        subtitle: Column(
          children: <Widget>[
            Text(
              'Login with Facebook to see all the exciting posts and events happening at Eastside C3',
              style: Theme.of(context).textTheme.subtitle2,
            ),
            FacebookSignInButton(onPressed: login)
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import '../scoped-model/main.dart';

class FacebookLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return InkWell(
          onTap: model.login,
          child: ListTile(
            title: Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
            ),
            subtitle: Column(
              children: <Widget>[
                Text(
                  'Login with Facebook to see all the exciting posts and events happening at Eastside C3',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                FacebookSignInButton(onPressed: model.login)
              ],
            ),
          ),
        );
      },
    );
  }
}

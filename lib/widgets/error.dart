import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Error extends StatelessWidget {
  final String error;
  Error(this.error);
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(
          MdiIcons.alertCircleOutline,
          color: Theme.of(context).accentColor,
        ),
        title: Text(
          'Error',
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          error,
          style: Theme.of(context).textTheme.subtitle2,
        ));
  }
}

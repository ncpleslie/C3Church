import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Error extends StatelessWidget {
  final String message;
  final String errorStatement;
  final Function onPressed;
  Error(
      {this.message =
          "Oops! We failed to get any data. This shouldn't happen. Are you connected to the internet?",
      this.errorStatement,
      this.onPressed});
  @override
  Widget build(BuildContext context) {
    if (errorStatement == null) print(errorStatement);
    return ListTile(
      leading: Icon(
        MdiIcons.alertCircleOutline,
        color: Theme.of(context).accentColor,
      ),
      title: Text(
        'Oops!',
        style: Theme.of(context).textTheme.headline6,
      ),
      subtitle: Text(
        message,
        style: Theme.of(context).textTheme.subtitle2,
      ),
      trailing: IconButton(
        icon: Icon(Icons.refresh),
        onPressed: onPressed,
      ),
    );
  }
}

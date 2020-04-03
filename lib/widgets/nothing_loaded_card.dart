import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NothingLoadedCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function callback;
  NothingLoadedCard({this.title, this.subtitle, this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(0.0),
        )),
        elevation: 0,
        color: Theme.of(context).cardColor,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: ListTile(
          leading: SizedBox.fromSize(
            size: const Size(40, 40),
            child: Icon(
              MdiIcons.emoticonSadOutline,
              color: Theme.of(context).primaryColor,
              size: 30,
            ),
          ),
          title: Text(
            title,
            style: Theme.of(context).textTheme.headline6,
          ),
          subtitle: Text(
            subtitle,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          trailing: IconButton(
              icon: Icon(Icons.refresh), onPressed: () => callback()),
        ),
      ),
    );
  }
}

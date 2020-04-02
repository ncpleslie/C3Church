import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-model/main.dart';
import '../widgets/location_card.dart';

class LocationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        top: true,
        child: ScopedModelDescendant(
          builder: (BuildContext context, Widget child, MainModel model) {
            return ListView(children: <Widget>[LocationCard(model)]);
          },
        ),
      ),
    );
  }
}

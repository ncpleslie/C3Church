import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../scoped-model/main.dart';
import '../widgets/service_card.dart';
import '../widgets/secondary_card.dart';
import '../widgets/location_card.dart';
import '../themes/style.dart';
import '../globals/app_data.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            appLogo,
            SizedBox(
              width: 10,
            ),
            Text(
              APP_NAME,
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () => Navigator.pushNamed(context, 'settings'),
          )
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
          _subscribeToNotifications(model);
          return _buildList(model, context);
        },
      ),
    );
  }

  final List<String> _imageURLs = [
    GET_IN_TOUCH_IMG_URL,
  ];

  Widget _buildList(MainModel model, BuildContext context) {
    return ListView(
      children: <Widget>[
        ServiceCard(model),
        SecondaryCard(
          imageURL: _imageURLs[0],
          primaryTitle: 'Get In Touch',
          secondaryTitle: 'Lots of ways to reach us',
          subtitle: 'Find out how',
          contentWidget: LocationCard(model),
          model: model,
        ),
        SizedBox(
          height: 40.0,
        )
      ],
      physics: const AlwaysScrollableScrollPhysics(),
    );
  }

  _subscribeToNotifications(MainModel model) {
    model.initNotifications();
  }
}

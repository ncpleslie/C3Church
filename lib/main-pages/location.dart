import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-model/main.dart';

class LocationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        top: true,
        child: ScopedModelDescendant(
          builder: (BuildContext context, Widget child, MainModel model) {
            return ListView(
                children: <Widget>[buildLocationCard(context, model)]);
          },
        ),
      ),
    );
  }

  Widget buildLocationCard(BuildContext context, MainModel model) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(0.0),
      )),
      elevation: 0,
      color: Theme.of(context).cardColor,
      child: InkWell(
        onTap: () => model.loadMaps(context),
        child: Column(
          children: <Widget>[
            Card(
              elevation: 0,
              child: Image.asset(
                'assets/placeholder.png',
                scale: 2,
              ),
            ),
            ListTile(
              title: Text(
                '269 Hills Road, Mairehau',
                style: Theme.of(context).textTheme.headline6,
              ),
              subtitle: Text(
                'Sunday: 10AM & 7PM',
                style: Theme.of(context).textTheme.subtitle2,
              ),
              trailing: Container(
                margin: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(model.context).accentColor),
                child: IconButton(
                  padding: EdgeInsets.all(0.0),
                  alignment: Alignment.center,
                  icon: Icon(
                    Icons.location_on,
                    color: Theme.of(context).primaryColor,
                    size: 30.0,
                  ),
                  onPressed: () => model.loadMaps(context),
                ),
              ),
            ),
            _buttonRow(model)
          ],
        ),
      ),
    );
  }

  Widget _buttonRow(MainModel model) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildButton(model,
              icon: Icons.phone, title: 'Call', onPress: model.call),
          _buildButton(model,
              icon: Icons.email, title: 'Email', onPress: model.email),
          _buildButton(model,
              icon: Icons.web, title: 'Web', onPress: model.website)
        ],
      ),
    );
  }

  Widget _buildButton(MainModel model, {IconData icon, String title, onPress}) {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      color: Theme.of(model.context).accentColor,
      textColor: Theme.of(model.context).primaryColor,
      child: Row(
        children: <Widget>[
          Icon(
            icon,
          ),
          Text(
            title,
          ),
        ],
      ),
      onPressed: () => onPress(),
    );
  }
}

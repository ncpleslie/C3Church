import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../scoped-model/main.dart';
import '../globals/app_data.dart';

class LocationCard extends StatelessWidget {
  final MainModel model;
  LocationCard(this.model);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(0.0),
      )),
      elevation: 0,
      color: Theme.of(context).cardColor,
      child: Column(
        children: <Widget>[
          InkWell(
              onTap: () => model.loadMaps(context),
              child: Card(
                elevation: 0,
                child: Image.asset(
                  LOCATION_IMG_URL,
                  scale: 2,
                ),
              )),
          _buttonRow(model),
          Divider(
            color: Theme.of(context).accentColor,
          ),
          InkWell(
            onTap: () => model.loadMaps(context),
            child: ListTile(
              title: Text(
                ADDRESS,
                style: Theme.of(context).textTheme.headline6,
              ),
              subtitle: Text(
                TIME_OF_SERVICE,
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
          ),
          Divider(
            color: Theme.of(context).accentColor,
          ),
          _socialRow(context, model),
        ],
      ),
    );
  }

  Widget _buttonRow(MainModel model) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

  Widget _socialRow(BuildContext context, MainModel model) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildButton(model,
              icon: MdiIcons.facebook,
              title: '',
              onPress: () => model.website(website: FACEBOOK)),
          Container(
            color: Theme.of(context).accentColor,
            height: 30,
            width: 0.5,
          ),
          _buildButton(model,
              icon: MdiIcons.twitter,
              title: '',
              onPress: () => model.website(website: TWITTER)),
          Container(
            color: Theme.of(context).accentColor,
            height: 30,
            width: 0.5,
          ),
          _buildButton(model,
              icon: MdiIcons.instagram,
              title: '',
              onPress: () => model.website(website: INSTAGRAM))
        ],
      ),
    );
  }

  Widget _buildButton(MainModel model,
      {IconData icon, String title, Function onPress}) {
    return RaisedButton(
      elevation: 0,
      shape: title.length == 0
          ? CircleBorder()
          : RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
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

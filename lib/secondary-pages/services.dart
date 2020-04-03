import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../scoped-model/main.dart';
import '../globals/app_data.dart';

class ServicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        title: Text(
          'Eastside C3 Services',
          style: Theme.of(context).textTheme.headline6,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
      ),
      body: _buildBody(context),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  Widget _buildBody(context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ListView(
          children: <Widget>[
            Card(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                Radius.circular(0.0),
              )),
              elevation: 0,
              color: Theme.of(context).cardColor,
              child: Column(
                children: <Widget>[
                  Hero(
                    tag: 'services',
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: Center(
                          child: Icon(Icons.error),
                        ),
                      ),
                      imageUrl: SERVICE_IMG_URL,
                    ),
                  ),
                  ListTile(
                    title: Column(
                      children: <Widget>[
                        _buttonRow(model),
                        Divider(
                          color: Theme.of(context).accentColor,
                        ),
                        InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                ADDRESS,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              _locationIcon(model)
                            ],
                          ),
                          onTap: () => model.loadMaps(context),
                        ),
                        Divider(
                          color: Theme.of(context).accentColor,
                        ),
                        Text(
                          TIME_OF_SERVICE,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        Divider(
                          color: Theme.of(context).accentColor,
                        ),
                        Text(
                          SERVICE_MESSAGE_ONE,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        Divider(
                          color: Theme.of(context).accentColor,
                        ),
                        Text(
                          SERVICE_MESSAGE_TWO,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
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

  Widget _locationIcon(MainModel model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: Theme.of(model.context).accentColor),
      child: IconButton(
        icon: Icon(
          Icons.location_on,
          color: Theme.of(model.context).primaryColor,
          size: 30.0,
        ),
        onPressed: () => model.loadMaps(model.context),
      ),
    );
  }
}

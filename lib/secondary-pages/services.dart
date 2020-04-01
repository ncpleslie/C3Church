import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-model/main.dart';

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
    String address = "269 Hills Road \nMairehau, Christchurch";
    String timeOfService = "Every Sunday at 10am & 7pm";
    String messageOne =
        "WELCOME\nIf you're new, you're not alone! There are new people who join our church each week. We think this is a great family to be part of and we hope that you feel right at home.  Here are the some great ways to get involved at church";
    String messageTwo =
        "WHAT TO EXPECT ON SUNDAY\nAnyone and everyone is welcome at our Sunday services! There is no dress code --just wear whatever you feel comfortable in. We have kids programmes for ages 0-12 yr olds. The style of worship is modern and upbeat and one of our pastors will share a 30 minute message from the Bible. Stay afterwards for a cuppa and meet some new people.";
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
                  Image.asset('assets/service.png'),
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
                                address,
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
                          timeOfService,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        Divider(
                          color: Theme.of(context).accentColor,
                        ),
                        Text(
                          messageOne,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        Divider(
                          color: Theme.of(context).accentColor,
                        ),
                        Text(
                          messageTwo,
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

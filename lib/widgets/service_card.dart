import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import '../scoped-model/main.dart';
import '../globals/app_data.dart';

class ServiceCard extends StatelessWidget {
  final MainModel model;
  ServiceCard(this.model);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(model.context).cardColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(0.0),
      )),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, 'service');
        },
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 3,
              child: Card(
                elevation: 0,
                margin: EdgeInsets.all(0.0),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      width: MediaQuery.of(context).size.width,
                      child: Hero(
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
                    ),
                    Positioned(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: Text('Service',
                            textScaleFactor: 2,
                            style: Theme.of(model.context).textTheme.headline5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: AutoSizeText(
                TIME_OF_SERVICE,
                style: Theme.of(model.context).textTheme.headline6,
              ),
              subtitle: AutoSizeText(
                ADDRESS,
                style: Theme.of(model.context).textTheme.subtitle2,
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
                    size: 30.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () => model.loadMaps(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

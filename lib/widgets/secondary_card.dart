import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import '../scoped-model/main.dart';

class SecondaryCard extends StatelessWidget {
  final String imageURL;
  final String primaryTitle;
  final String secondaryTitle;
  final String subtitle;
  final Widget contentWidget;
  final MainModel model;

  SecondaryCard(
      {@required this.imageURL,
      @required this.contentWidget,
      @required this.primaryTitle,
      @required this.secondaryTitle,
      @required this.subtitle,
      @required this.model});

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
        onTap: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return Container(
                  child: Wrap(
                children: <Widget>[contentWidget],
              ));
            }),
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 4,
              child: Card(
                elevation: 0,
                margin: EdgeInsets.all(0.0),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      width: MediaQuery.of(context).size.width,
                      right: 0,
                      child: CachedNetworkImage(
                        imageUrl: imageURL,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          primaryTitle,
                          textScaleFactor: 2,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Text(
                secondaryTitle,
                style: Theme.of(model.context).textTheme.headline6,
              ),
              subtitle: Text(
                subtitle,
                style: Theme.of(model.context).textTheme.subtitle2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

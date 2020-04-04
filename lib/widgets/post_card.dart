import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import '../scoped-model/main.dart';

class PostCard extends StatelessWidget {
  final MainModel model;
  final String id;
  final String imgUrl;
  final String message;
  final String createdTime;
  PostCard({this.model, this.id, this.imgUrl, this.message, this.createdTime});
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
            imgUrl != null
                ? Container(
                    height: MediaQuery.of(context).size.height / 2.5,
                    child: Card(
                      elevation: 0,
                      margin: EdgeInsets.all(0.0),
                      child: Hero(
                        tag: id,
                        child: CachedNetworkImage(
                          fit: BoxFit.contain,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => Center(
                            child: Center(
                              child: Icon(Icons.error),
                            ),
                          ),
                          imageUrl: imgUrl,
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    height: 1,
                  ),
            ListTile(
              title: Text(
                createdTime,
                style: Theme.of(model.context).textTheme.subtitle2,
              ),
              subtitle: Text(
                message,
                style: Theme.of(model.context).textTheme.headline6,
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

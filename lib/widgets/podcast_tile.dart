import 'package:flutter/material.dart';

import '../models/podcasts.dart';
import '../scoped-model/main.dart';
import '../globals/app_data.dart';

class PodcastTile extends StatelessWidget {
  final MainModel model;
  final Podcast data;
  PodcastTile(this.data, this.model);

  @override
  Widget build(BuildContext context) {
    return _buildStack();
  }

  Widget _buildStack() {
    return Container(
      child: Stack(
        children: <Widget>[
          Positioned(
            child: _buildPodcastTile(),
          ),
          Positioned(
              top: 15.0,
              left: 15.0,
              child: Container(
                height: 50.0,
                width: 50.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: ExactAssetImage(PODCAST_IMG_URL),
                    )),
              ))
        ],
      ),
    );
  }

  Widget _buildPodcastTile() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Theme.of(model.context).cardColor),
        child: ExpansionTile(
            title: Padding(
              padding: EdgeInsets.only(left: 52.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    data.title != null ? data.title : "Title failed to load",
                    style: Theme.of(model.context).textTheme.headline6,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    data.date != null ? data.date : "Date failed to load",
                    style: Theme.of(model.context).textTheme.subtitle2,
                  )
                ],
              ),
            ),
            children: <Widget>[
              ListTile(
                subtitle: Text(
                  data.summary != null
                      ? data.summary
                      : "Summary failed to load",
                  style: Theme.of(model.context).textTheme.subtitle2,
                ),
              ),
              Container(
                margin: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(model.context).accentColor),
                child: IconButton(
                  iconSize: 30.0,
                  icon: Icon(Icons.play_circle_outline),
                  color: Theme.of(model.context).primaryColor,
                  onPressed: () => model.website(website: data.link),
                ),
              ),
            ]),
      ),
    );
  }
}

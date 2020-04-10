import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/podcasts.dart';
import '../scoped-model/main.dart';

class PodcastTile extends StatefulWidget {
  final MainModel model;
  final Podcast data;
  PodcastTile(this.data, this.model);
  @override
  State<StatefulWidget> createState() {
    return _PodcastTileState(data, model);
  }
}

class _PodcastTileState extends State<PodcastTile> {
  final MainModel model;
  final Podcast data;
  _PodcastTileState(this.data, this.model);

  @override
  Widget build(BuildContext context) {
    return _buildStack();
  }

  Widget _buildStack() {
    return Container(
      child: Stack(
        children: <Widget>[_buildPodcastTile(), _buildImage()],
      ),
    );
  }

  Widget _buildImage() {
    return Positioned(
      top: 5.0,
      left: 5.0,
      child: Container(
        height: 70.0,
        width: 70.0,
        child: CachedNetworkImage(
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Center(
            child: Center(
              child: Icon(Icons.error),
            ),
          ),
          imageUrl: data.image,
        ),
      ),
    );
  }

  bool _open = false;

  Widget _buildPodcastTile() {
    return Positioned(
      child: Card(
        elevation: 0,
        margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
        child: Container(
          decoration: BoxDecoration(color: Theme.of(model.context).cardColor),
          child: ExpansionTile(
              onExpansionChanged: ((status) => {
                    setState(() {
                      _open = status;
                    })
                  }),
              title: Padding(
                padding: EdgeInsets.fromLTRB(70.0, 5.0, 0, 5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      data.title != null ? data.title : "Title failed to load",
                      style: Theme.of(model.context).textTheme.headline4,
                      maxLines: _open ? 4 : 1,
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
                  subtitle: Padding(
                    padding: EdgeInsets.fromLTRB(70.0, 10.0, 0, 0.0),
                    child: Text(
                      data.summary != null
                          ? data.summary
                          : "Summary failed to load",
                      style: Theme.of(model.context).textTheme.subtitle2,
                    ),
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
      ),
    );
  }
}

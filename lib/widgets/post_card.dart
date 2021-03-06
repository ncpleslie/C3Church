import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../scoped-model/main.dart';
import '../models/posts.dart';
import '../secondary-pages/posts.dart';

class PostCard extends StatelessWidget {
  final MainModel model;
  final String id;
  final DateTime createdTime;
  final String imgUrl;
  final String fullImgUrl;
  final String message;
  final String link;
  final String statusType;
  final String story;
  final List<dynamic> comments;
  final Video video;
  PostCard(
      {this.model,
      this.id,
      this.imgUrl,
      this.fullImgUrl,
      this.message,
      this.createdTime,
      this.link,
      this.statusType,
      this.story,
      this.comments,
      this.video});

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
        onTap: () => _loadRoute(context),
        child: Container(
          decoration: BoxDecoration(color: Theme.of(model.context).cardColor),
          child: Column(
            children: <Widget>[
              _buildImage(context),
              _buildTitle(context),
              // _buildCommentCount(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return imgUrl != null
        ? Container(
            height: MediaQuery.of(context).size.height / 3,
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Stack(
              children: <Widget>[
                Positioned(
                  width: MediaQuery.of(context).size.width,
                  child: Hero(
                    tag: id,
                    child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        placeholder: (context, url) => Center(
                              child: LinearProgressIndicator(),
                            ),
                        errorWidget: (context, url, error) => Center(
                              child: Center(
                                child: Icon(Icons.error),
                              ),
                            ),
                        imageUrl: fullImgUrl),
                  ),
                ),
                _buildPlayButton(context),
              ],
            ))
        : Container();
  }

  void _loadRoute(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostPage(
          Post(
              id: id,
              picture: imgUrl,
              fullPicture: fullImgUrl,
              message: message,
              createdTime: createdTime,
              link: link,
              statusType: statusType,
              story: story,
              comments: comments,
              video: video),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0, 0.0),
        child: Text(
          timeago.format(createdTime),
          style: Theme.of(model.context).textTheme.subtitle2,
        ),
      ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          message.length != 0
              ? Text(
                  message,
                  style: Theme.of(model.context).textTheme.headline4,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              : Container(),
          Text(
            'Comments: ${comments.length}',
            style: Theme.of(model.context).textTheme.subtitle2,
          ),
        ],
      ),
      trailing: Container(
        margin: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Theme.of(model.context).accentColor),
        child: IconButton(
          padding: EdgeInsets.all(0.0),
          alignment: Alignment.center,
          icon: Icon(
            MdiIcons.arrowRight,
            size: 30.0,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () => _loadRoute(context),
        ),
      ),
    );
  }

  Widget _buildPlayButton(BuildContext context) {
    return statusType != null && statusType.toLowerCase().contains("video")
        ? Positioned(
            child: Container(
              alignment: Alignment.center,
              child: IconButton(
                icon: Icon(Icons.play_circle_outline),
                color: Theme.of(context).cardColor,
                iconSize: 100,
                onPressed: () => _loadRoute(context),
              ),
            ),
          )
        : Container();
  }
}

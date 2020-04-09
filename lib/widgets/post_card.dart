import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../scoped-model/main.dart';
import '../models/posts.dart';

class PostCard extends StatelessWidget {
  final MainModel model;
  final String id;
  final String createdTime;
  final String imgUrl;
  final String fullImgUrl;
  final String message;
  final String link;
  final String statusType;
  final String story;
  final List<dynamic> comments;
  final int commentCount;
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
      this.commentCount});
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
          child: Stack(
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
            width: MediaQuery.of(context).size.width / 3,
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.symmetric(horizontal: 12.5, vertical: 12.5),
            child: Stack(
              children: <Widget>[
                Positioned(
                  width: MediaQuery.of(context).size.width,
                  child: Hero(
                    tag: id,
                    child: CachedNetworkImage(
                      fit: BoxFit.fitWidth,
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
                _buildPlayButton(context),
              ],
            ))
        : Container();
  }

  void _loadRoute(BuildContext context) {
    Navigator.pushNamed(context, 'posts',
        arguments: Post(
          id: id,
          picture: imgUrl,
          fullPicture: fullImgUrl,
          message: message,
          createdTime: createdTime,
          link: link,
          statusType: statusType,
          story: story,
          comments: comments,
        ));
  }

  Widget _buildCommentCount(BuildContext context) {
    return ListTile(
      title: Text(
        'Comments: $commentCount',
        style: Theme.of(model.context).textTheme.subtitle2,
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: EdgeInsets.fromLTRB(120.0, 0.0, 0, 0.0),
        child: Text(
          createdTime,
          style: Theme.of(model.context).textTheme.subtitle2,
        ),
      ),
      subtitle: Column(
        children: <Widget>[
          message.length != 0
              ? Padding(
                  padding: EdgeInsets.fromLTRB(50.0, 0.0, 0, 0.0),
                  child: Text(
                    message,
                    style: Theme.of(model.context).textTheme.headline4,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              : Container(),
          Padding(
            padding: EdgeInsets.fromLTRB(64.0, 0.0, 0, 0.0),
            child: Text(
              'Comments: ${comments.length}',
              style: Theme.of(model.context).textTheme.subtitle2,
            ),
          )
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
    return story != null && story.toLowerCase().contains("live")
        ? Positioned(
            child: Container(
              alignment: Alignment.center,
              child: Icon(
                Icons.play_circle_outline,
                color: Theme.of(context).cardColor,
                size: 100,
              ),
            ),
          )
        : Container();
  }
}

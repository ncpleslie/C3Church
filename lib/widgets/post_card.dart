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
  final String message;
  final String link;
  final List<dynamic> comments;
  final int commentCount;
  PostCard(
      {this.model,
      this.id,
      this.imgUrl,
      this.message,
      this.createdTime,
      this.link,
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
        child: Column(
          children: <Widget>[
            _buildTitle(context),
            _buildImage(context),
            _buildCommentCount(context)
          ],
        ),
      ),
    );
  }

  void _loadRoute(BuildContext context) {
    Navigator.pushNamed(context, 'posts',
        arguments: Post(
          id: id,
          picture: imgUrl,
          message: message,
          createdTime: createdTime,
          link: link,
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
      title: Text(
        createdTime,
        style: Theme.of(model.context).textTheme.subtitle2,
      ),
      subtitle: message.length != 0
          ? Text(
              message,
              style: Theme.of(model.context).textTheme.headline4,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            )
          : Container(),
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

  Widget _buildImage(BuildContext context) {
    return imgUrl != null
        ? Container(
            height: MediaQuery.of(context).size.height / 2.5,
            child: Card(
              elevation: 0,
              margin: EdgeInsets.all(0.0),
              child: Hero(
                tag: id,
                child: CachedNetworkImage(
                  fit: BoxFit.fill,
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
        : Container();
  }
}

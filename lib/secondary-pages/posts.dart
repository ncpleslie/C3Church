import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../scoped-model/main.dart';
import '../models/posts.dart';

class PostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Post args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
      ),
      body: _buildBody(context, args),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  Widget _buildBody(BuildContext context, Post args) {
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
                  _buildPicture(context, model, args),
                  _buildTitle(context, model, args),
                  _buildLinkBar(context, model, args),
                ],
              ),
            ),
            _buildComments(context, model, args)
          ],
        );
      },
    );
  }

  Widget _buildPicture(BuildContext context, MainModel model, Post args) {
    return args.fullPicture != null
        ? Container(
            height: MediaQuery.of(context).size.height / 2.5,
            child: Card(
                elevation: 0,
                margin: EdgeInsets.all(0.0),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      child: Hero(
                        tag: args.id,
                        child: Container(
                          alignment: Alignment.center,
                          child: CachedNetworkImage(
                            alignment: Alignment.center,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Center(
                              child: Center(
                                child: Icon(Icons.error),
                              ),
                            ),
                            imageUrl: args.fullPicture,
                          ),
                        ),
                      ),
                    ),
                    _buildPlayButton(context, model, args),
                  ],
                )),
          )
        : Container();
  }

  Widget _buildPlayButton(BuildContext context, MainModel model, Post args) {
    return args.statusType != null &&
            args.statusType.toLowerCase().contains("video")
        ? Positioned(
            child: Container(
              alignment: Alignment.center,
              child: IconButton(
                icon: Icon(Icons.play_circle_outline),
                color: Theme.of(context).cardColor,
                iconSize: 100,
                onPressed: () => model.website(website: args.link),
              ),
            ),
          )
        : Container();
  }

  Widget _buildTitle(BuildContext context, MainModel model, Post args) {
    return ListTile(
      title: Text(
        timeago.format(DateTime.parse(args.createdTime)),
        style: Theme.of(context).textTheme.subtitle2,
      ),
      subtitle: args.message.length != 0
          ? Text(
              args.message,
              style: Theme.of(context).textTheme.headline4,
            )
          : Container(),
    );
  }

  Widget _buildComments(BuildContext context, MainModel model, Post args) {
    return ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 10),
        separatorBuilder: (BuildContext context, int index) =>
            Padding(padding: EdgeInsets.symmetric(vertical: 2)),
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: args.comments.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              title: Text(
                args.comments[index].message,
                style: Theme.of(context).textTheme.headline4,
              ),
              subtitle: Text(
                timeago
                    .format(DateTime.parse(args.comments[index].createdTime)),
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
          );
        });
  }

  Widget _buildLinkBar(BuildContext context, MainModel model, Post args) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildButton(context, model,
              icon: MdiIcons.facebook,
              title: ' See on Facebook',
              onPress: () => model.website(website: args.link)),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, MainModel model,
      {IconData icon, String title, Function onPress}) {
    return RaisedButton(
      elevation: 0,
      shape: title.length == 0
          ? CircleBorder()
          : RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      color: Theme.of(context).accentColor,
      textColor: Theme.of(context).primaryColor,
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
}

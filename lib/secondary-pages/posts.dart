import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import '../scoped-model/main.dart';
import '../models/posts.dart';

class PostPage extends StatefulWidget {
  final Post post;
  PostPage(this.post);
  @override
  State<StatefulWidget> createState() {
    return _PostPageState(post);
  }
}

class _PostPageState extends State<PostPage> {
  final Post post;
  VideoPlayerController _controller;
  ChewieController _chewieController;
  Future<void> _future;
  _PostPageState(this.post);

  @override
  void initState() {
    super.initState();
    if (post.video != null && post.video.source != null) {
      _controller = VideoPlayerController.network(post.video.source);
      _future = _initVideoPlayer();
    }
  }

  Future<void> _initVideoPlayer() async {
    await _controller.initialize();
    setState(() {
      _chewieController = ChewieController(
          videoPlayerController: _controller,
          aspectRatio: _controller.value.aspectRatio,
          autoPlay: true,
          placeholder: _buildPlaceholderImage());
    });
  }

  _buildPlaceholderImage() {
    return Center(
      child: LinearProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
      ),
      body: _buildBody(context),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  Widget _buildBody(BuildContext context) {
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
                  post.video != null
                      ? _buildVideo(context, model)
                      : _buildPicture(context, model),
                  _buildTitle(context, model),
                  _buildLinkBar(context, model),
                ],
              ),
            ),
            _buildComments(context, model)
          ],
        );
      },
    );
  }

  Widget _buildVideo(BuildContext context, MainModel model) {
    return FutureBuilder(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return _buildPlaceholderImage();
        return Container(
          height: MediaQuery.of(context).size.height / 2.5,
          child: Card(
            elevation: 0,
            margin: EdgeInsets.all(0.0),
            child: Hero(
              tag: post.id,
              child: Center(
                child: Chewie(
                  controller: _chewieController,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPicture(BuildContext context, MainModel model) {
    return post.fullPicture != null
        ? Container(
            height: MediaQuery.of(context).size.height / 2.5,
            child: Card(
              elevation: 0,
              margin: EdgeInsets.all(0.0),
              child: Hero(
                tag: post.id,
                child: Container(
                  alignment: Alignment.center,
                  child: CachedNetworkImage(
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => Center(
                      child: LinearProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Center(
                      child: Center(
                        child: Icon(Icons.error),
                      ),
                    ),
                    imageUrl: post.fullPicture,
                  ),
                ),
              ),
            ),
          )
        : Container();
  }

  Widget _buildTitle(BuildContext context, MainModel model) {
    return ListTile(
      title: Text(
        timeago.format(post.createdTime),
        style: Theme.of(context).textTheme.subtitle2,
      ),
      subtitle: post.message.length != 0
          ? Text(
              post.message,
              style: Theme.of(context).textTheme.headline4,
            )
          : Container(),
    );
  }

  Widget _buildComments(BuildContext context, MainModel model) {
    return ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 10),
        separatorBuilder: (BuildContext context, int index) =>
            Padding(padding: EdgeInsets.symmetric(vertical: 2)),
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: post.comments.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              title: Text(
                post.comments[index].message,
                style: Theme.of(context).textTheme.headline4,
              ),
              subtitle: Text(
                timeago.format(post.comments[index].createdTime),
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
          );
        });
  }

  Widget _buildLinkBar(BuildContext context, MainModel model) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildButton(context, model,
              icon: MdiIcons.facebook,
              title: ' See on Facebook',
              onPress: () => model.website(website: post.link)),
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

  @override
  void dispose() {
    if (_controller != null) _controller.dispose();
    if (_chewieController != null) _chewieController.dispose();
    super.dispose();
  }
}

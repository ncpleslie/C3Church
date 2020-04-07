import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../scoped-model/main.dart';
import '../models/posts.dart';

class PostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Post args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme.of(context).backgroundColor,
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
                  Hero(
                    tag: args.id,
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: Center(
                          child: Icon(Icons.error),
                        ),
                      ),
                      imageUrl: args.picture,
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}

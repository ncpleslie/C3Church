import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-model/main.dart';
import '../models/podcasts.dart';
import '../widgets/podcast_tile.dart';

class MediaPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MediaPageState();
  }
}

class _MediaPageState extends State<MediaPage> {
  @override
  void initState() {
    super.initState();
    MainModel _model = ScopedModel.of(context);
    _preloadData(_model);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: SafeArea(
            top: true,
            child: StreamBuilder(
              stream: model.getPodcastList,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                      children: snapshot.data
                          .map<Widget>(
                              (Podcasts data) => PodcastTile(data, model))
                          .toList());
                } else {
                  _preloadData(model);
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  bool _loopPrevent = true;
  void _preloadData(MainModel model) async {
    if (_loopPrevent) {
      _loopPrevent = false;
      await model.getPodcasts();
    }
  }
}

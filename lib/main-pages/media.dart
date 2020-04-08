import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-model/main.dart';
import '../models/podcasts.dart';
import '../widgets/podcast_tile.dart';
import '../widgets/nothing_loaded_card.dart';
import '../widgets/error.dart';

class MediaPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MediaPageState();
  }
}

class _MediaPageState extends State<MediaPage> {
  List<Podcast> _podcasts;
  MainModel _model;
  Future _podcastFuture;

  @override
  void initState() {
    super.initState();
    _model = ScopedModel.of(context);
    _podcastFuture = _model.getPodcasts();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        _model = model;
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: SafeArea(
            top: true,
            child: _buildFutureListView(context),
          ),
        );
      },
    );
  }

  ListView _buildListView() {
    return ListView.builder(
      itemCount: _podcasts != null ? _podcasts.length : 0,
      itemBuilder: (BuildContext context, int index) {
        return PodcastTile(_podcasts[index], _model);
      },
    );
  }

  Widget _buildFutureListView(BuildContext context) {
    return FutureBuilder<List<Podcast>>(
      future: _podcastFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          _podcasts = snapshot.data;
          if (_podcasts == null || _podcasts.length == 0) {
            return NothingLoadedCard(
                title: "No Podcasts",
                subtitle: "It seems like there are no podcasts. Strange...",
                callback: _refresh);
          }
          return _buildListView();
        } else if (snapshot.hasError) {
          return Error(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  void _refresh() {
    print("Refreshing");
  }
}

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

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
  MainModel _model;

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

  Widget _buildFutureListView(BuildContext context) {
    return FutureBuilder<List<Podcast>>(
      future: _model.getPodcasts(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          // If can't find podcasts then display an error card
          // giving the user the option to refresh
          if (snapshot.data == null || snapshot.data.length == 0) {
            return NothingLoadedCard(
                title: "No Podcasts",
                subtitle: "It seems like there are no podcasts. Strange...",
                onPressed: _model.updatePodcasts);
          }
          // Display the podcast tiles
          return _buildListView(snapshot.data);
        } else if (snapshot.hasError) {
          // If error, for whatever reason, display an error widget
          // with ability for user to refresh
          return Error(
            onPressed: _model.updatePodcasts,
            errorStatement: snapshot.error.toString(),
          );
        }
        // Show progress bar by default
        return Center(child: LinearProgressIndicator());
      },
    );
  }

  LiquidPullToRefresh _buildListView(List<Podcast> podcasts) {
    return LiquidPullToRefresh(
      showChildOpacityTransition: false,
      onRefresh: _model.updatePodcasts,
      child: ListView.builder(
        itemCount: podcasts != null ? podcasts.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return PodcastTile(podcasts[index], _model);
        },
      ),
    );
  }
}

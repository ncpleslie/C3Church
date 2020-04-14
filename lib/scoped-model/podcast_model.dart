import 'package:http/http.dart' as http;

import 'connected_model.dart';
import '../models/podcasts.dart';
import '../globals/app_data.dart';
import '../utils/utils.dart';

mixin PodcastModel on ConnectedModel {
  final String _podcastURL = PODCAST;
  int maxNum = 10;
  Future _podcastFuture;

  Future getPodcasts() {
    if (_podcastFuture == null) {
      _podcastFuture = _getPodcasts();
    }
    return _podcastFuture;
  }

  Future<List<Podcast>> _getPodcasts() async {
    print('Fetching Podcasts');
    startFunction();
    final http.Response response = await fetch(_podcastURL);
    final json = convertXMLtoJSON(response.body);
    Iterable list = json['rss']['channel']['item'];
    endFunction();
    return list
        .map((podcast) => Podcast.fromJson(podcast))
        .take(maxNum)
        .toList();
  }

  Future updatePodcasts() {
    _podcastFuture = _getPodcasts();
    return _podcastFuture;
  }
}

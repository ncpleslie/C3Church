import 'dart:convert';
import 'package:http/http.dart' as http;

import './connected_model.dart';
import '../models/posts.dart';
import '../globals/app_data.dart';

mixin PostModel on ConnectedModel {
  final String _postUrl = FACEBOOK_POST_URL + "&access_token=";
  Future _postFuture;

  Future getPosts() {
    if (_postFuture == null) {
      _postFuture = _getPosts();
    }
    return _postFuture;
  }

  Future<List<dynamic>> _getPosts() async {
    try {
      print('Fetching Facebook Posts');
      startFunction();
      final http.Response response = await fetch(_postUrl + token);
      endFunction();
      return jsonDecode(response.body)['posts']['data']
          .map((post) => Post.fromJson(post, location))
          .toList();
    } catch (e, stack) {
      throw Exception(
          "Tried fetching posts.\n$e.\nTrace: $stack.\nToken status: ${token != null}");
    }
  }

  Future updatePosts() {
    _postFuture = _getPosts();
    return _postFuture;
  }
}

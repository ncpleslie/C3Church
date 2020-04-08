import 'package:intl/intl.dart';
import 'package:timezone/standalone.dart';

class Post {
  final String id;
  final String createdTime;
  final String picture;
  final String message;
  final String link;
  final List<dynamic> comments;
  Post({
    this.id,
    this.createdTime,
    this.picture,
    this.message,
    this.link,
    this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json, Location location) {
    final String id = json['id'] != null ? json['id'] : "NoID";
    final String createdTime = json['created_time'] != null
        ? DateFormat('kk:mm - dd-MM-yyyy').format(
            TZDateTime.from(DateTime.parse(json['created_time']), location))
        : "";
    final String picture =
        json['full_picture'] != null ? json['full_picture'] : null;
    final String message = json['message'] != null ? json['message'] : "";
    final String link =
        json['permalink_url'] != null ? json['permalink_url'] : "";
    final List<dynamic> comments = json['comments'] != null
        ? json['comments']['data']
            .map((comment) => Comment.fromJson(comment, location))
            .toList()
        : List<dynamic>();
    return Post(
      id: id,
      createdTime: createdTime,
      picture: picture,
      message: message,
      link: link,
      comments: comments,
    );
  }
}

class Comment {
  final String id;
  final String createdTime;
  final String message;
  Comment({this.id, this.createdTime, this.message});

  factory Comment.fromJson(Map<String, dynamic> json, Location location) {
    final String id = json['id'] != null ? json['id'] : 'NoID';
    final String createdTime = json['created_time'] != null
        ? DateFormat('kk:mm - dd-MM-yyyy').format(
            TZDateTime.from(DateTime.parse(json['created_time']), location))
        : "";
    final String message = json['message'] != null ? json['message'] : "";
    return Comment(id: id, createdTime: createdTime, message: message);
  }
}

import 'package:intl/intl.dart';
import 'package:timezone/standalone.dart';

class Post {
  final String id;
  final String createdTime;
  final String picture;
  final String fullPicture;
  final String message;
  final String link;
  final String statusType;
  final String story;
  final List<dynamic> comments;
  Post({
    this.id,
    this.createdTime,
    this.picture,
    this.fullPicture,
    this.message,
    this.link,
    this.statusType,
    this.story,
    this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json, Location location) {
    final String id = json['id'] != null ? json['id'] : "NoID";

    final String createdTime = json['created_time'] != null
        ? DateFormat('kk:mm - dd-MM-yyyy').format(
            TZDateTime.from(DateTime.parse(json['created_time']), location))
        : "";

    final String picture = json['picture'] != null ? json['picture'] : null;
    final String fullPicture =
        json['full_picture'] != null ? json['full_picture'] : null;

    final String message = json['message'] != null ? json['message'] : "";

    final String link =
        json['permalink_url'] != null ? json['permalink_url'] : "";

    final String statusType =
        json['status_type'] != null ? json['status_type'] : null;

    final String story = json['story'] != null ? json['story'] : null;

    final List<dynamic> comments = json['comments'] != null
        ? json['comments']['data']
            .map((comment) => Comment.fromJson(comment, location))
            .toList()
        : List<dynamic>();

    return Post(
      id: id,
      createdTime: createdTime,
      picture: picture,
      fullPicture: fullPicture,
      message: message,
      link: link,
      statusType: statusType,
      story: story,
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

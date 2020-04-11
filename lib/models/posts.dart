import 'package:timezone/standalone.dart';

class Post {
  final String id;
  final DateTime createdTime;
  final String picture;
  final String fullPicture;
  final String message;
  final String link;
  final String statusType;
  final String story;
  final List<dynamic> comments;
  final Video video;
  Post(
      {this.id,
      this.createdTime,
      this.picture,
      this.fullPicture,
      this.message,
      this.link,
      this.statusType,
      this.story,
      this.comments,
      this.video});

  factory Post.fromJson(Map<String, dynamic> json, Location location) {
    final String id = json['id'] != null ? json['id'] : "NoID";

    final DateTime createdTime = json['created_time'] != null
        ? TZDateTime.from(DateTime.parse(json['created_time']), location)
        : null;

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

    Video video;

    if (json['attachments'] != null &&
        json['attachments']['data'][0]['media_type'] == "video") {
      video = json['attachments']['data'][0]['media'] != null
          ? Video.fromJson(json['attachments']['data'][0])
          : null;
    } else {
      video = null;
    }

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
        video: video);
  }
}

class Comment {
  final String id;
  final DateTime createdTime;
  final String message;
  Comment({this.id, this.createdTime, this.message});

  factory Comment.fromJson(Map<String, dynamic> json, Location location) {
    final String id = json['id'] != null ? json['id'] : 'NoID';
    final DateTime createdTime = json['created_time'] != null
        ? TZDateTime.from(DateTime.parse(json['created_time']), location)
        : null;
    final String message = json['message'] != null ? json['message'] : "";
    return Comment(id: id, createdTime: createdTime, message: message);
  }
}

class Video {
  final String source;
  final int height;
  final int width;
  final String imageUrl;
  Video({this.source, this.height, this.width, this.imageUrl});

  factory Video.fromJson(Map<String, dynamic> json) {
    final String source =
        json['media']['source'] != null ? json['media']['source'] : null;
    final int height = json['media']['image'] != null
        ? json['media']['image']['height']
        : null;
    final int width =
        json['media']['image'] != null ? json['media']['image']['width'] : null;
    final imageUrl =
        json['media']['image'] != null ? json['media']['image']['src'] : null;
    return Video(
        source: source, height: height, width: width, imageUrl: imageUrl);
  }
}

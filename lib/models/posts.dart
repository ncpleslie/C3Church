import 'package:intl/intl.dart';
import 'package:timezone/standalone.dart';

class Post {
  final String id;
  final String createdTime;
  final String picture;
  final String message;
  Post({this.id, this.createdTime, this.picture, this.message});

  factory Post.fromJson(Map<String, dynamic> json, Location location) {
    final String id = json['id'] != null ? json['id'] : "NoID";
    final String createdTime = json['created_time'] != null
        ? DateFormat('kk:mm - dd-MM-yyyy').format(
            TZDateTime.from(DateTime.parse(json['created_time']), location))
        : "";
    final String picture =
        json['full_picture'] != null ? json['full_picture'] : null;
    final String message = json['message'] != null ? json['message'] : "";
    return Post(
        id: id, createdTime: createdTime, picture: picture, message: message);
  }
}

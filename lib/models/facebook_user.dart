import 'dart:convert';

class FacebookUser {
  final String userId;
  final String token;
  final DateTime expiryDate;
  FacebookUser({this.userId, this.token, this.expiryDate});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'token': token,
      'expiryDate': expiryDate.toIso8601String()
    };
  }

  String toJson() {
    return json.encode(this.toMap());
  }

  factory FacebookUser.fromJson(Map<String, dynamic> json) {
    return FacebookUser(
        userId: json['userId'],
        token: json['token'],
        expiryDate: DateTime.parse(json['expiryDate']));
  }
}

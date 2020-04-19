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

  factory FacebookUser.fromLink(String url) {
    final String accessToken =
        url.split("access_token=")[1].split("&")[0].toString();
    final int expires = int.parse(url.split("expires_in=")[1].split("&")[0]);
    final bool isNonExpiringToken = expires == -1;

    return FacebookUser(
        userId: null,
        token: accessToken,
        expiryDate: isNonExpiringToken
            ? DateTime.now().add(Duration(days: 60))
            : DateTime.now().add(Duration(seconds: expires)));
  }
}

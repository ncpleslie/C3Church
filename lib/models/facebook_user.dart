import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class FacebookUser {
  final FacebookAccessToken accessToken;
  FacebookUser(this.accessToken);

  Map<String, dynamic> toMap() {
    return {'access_token': accessToken};
  }
}

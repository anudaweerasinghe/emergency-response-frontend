import 'user_model.dart';

class OTPResponse {
  User user;
  String authUserName;
  String authPassword;

  OTPResponse({this.user, this.authUserName, this.authPassword});

  factory OTPResponse.fromJson(Map<String, dynamic> json) {

    return new OTPResponse(

      user: User.fromJson(json['user']),
      authUserName: json['authUserName'],
      authPassword: json['authPassword']

    );

  }
}
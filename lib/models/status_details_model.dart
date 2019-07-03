import 'user_model.dart';
import 'message_model.dart';
import 'user_status_model.dart';

class StatusDetails {
  Message message;
  List<UserStatus> safeUsers;
  List<UserStatus> affectedUsers;
  List<User> noResponseUsers;

  StatusDetails(
      {this.message, this.safeUsers, this.affectedUsers, this.noResponseUsers});

  factory StatusDetails.fromJson(Map<String, dynamic> json) {


    var safeUsersFromJson = json['safeUsers'] as List;
    List<UserStatus> safeUsersList = safeUsersFromJson.map<UserStatus>((json)=>UserStatus.fromJson(json)).toList();

    var affectedUsersFromJson = json['affectedUsers'] as List;
    List<UserStatus> affectedUsersList = affectedUsersFromJson.map<UserStatus>((json)=>UserStatus.fromJson(json)).toList();

    var noResponseUsersFromJson = json['noResponseUsers'];
    List<User> noResponseUsersList = noResponseUsersFromJson.map<User>((json)=>User.fromJson(json)).toList();


    return new StatusDetails(
      message: Message.fromJson(json['message']),
      safeUsers: safeUsersList,
      affectedUsers: affectedUsersList,
      noResponseUsers: noResponseUsersList,
    );
  }
}

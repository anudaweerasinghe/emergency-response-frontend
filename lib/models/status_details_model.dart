import 'user_model.dart';
import 'message_model.dart';

class StatusDetails {
  Message message;
  List<User> safeUsers;
  List<User> affectedUsers;
  List<User> noResponseUsers;

  StatusDetails(
      {this.message, this.safeUsers, this.affectedUsers, this.noResponseUsers});

  factory StatusDetails.fromJson(Map<String, dynamic> json) {


    var safeUsersFromJson = json['safeUsers'] as List;
    List<User> safeUsersList = safeUsersFromJson.map<User>((json)=>User.fromJson(json)).toList();

    var affectedUsersFromJson = json['affectedUsers'] as List;
    List<User> affectedUsersList = affectedUsersFromJson.map<User>((json)=>User.fromJson(json)).toList();

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

import 'user_model2.dart';
import 'message_model.dart';

class StatusDetails {
  Message message;
  List<User2> safeUsers;
  List<User2> affectedUsers;
  List<User2> noResponseUsers;

  StatusDetails(
      {this.message, this.safeUsers, this.affectedUsers, this.noResponseUsers});

  factory StatusDetails.fromJson(Map<String, dynamic> json) {


    var safeUsersFromJson = json['safeUsers'] as List;
    List<User2> safeUsersList = safeUsersFromJson.map<User2>((json)=>User2.fromJson(json)).toList();

    var affectedUsersFromJson = json['affectedUsers'] as List;
    List<User2> affectedUsersList = affectedUsersFromJson.map<User2>((json)=>User2.fromJson(json)).toList();

    var noResponseUsersFromJson = json['noResponseUsers'];
    List<User2> noResponseUsersList = noResponseUsersFromJson.map<User2>((json)=>User2.fromJson(json)).toList();


    return new StatusDetails(
      message: Message.fromJson(json['message']),
      safeUsers: safeUsersList,
      affectedUsers: affectedUsersList,
      noResponseUsers: noResponseUsersList,
    );
  }
}

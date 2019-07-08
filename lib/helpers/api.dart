import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:emergency_response_app/models/user_model.dart';
import 'package:emergency_response_app/models/message_model.dart';
import 'package:emergency_response_app/models/status_details_model.dart';
import 'package:emergency_response_app/models/otp_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emergency_response_app/models/tokens_model.dart';

const baseUrl = "http://localhost:8080";

Future<bool> getTokens() async{

  SharedPreferences pref1 = await SharedPreferences.getInstance();

  String grant_type = "password";
  String client_id = "mobile";
  String auth_type = "otp";
  String session = pref1.get("sessionId");
  String otp = pref1.get("otp");
  String mobileNumber = pref1.get("phone");


  String url = baseUrl+'/oauth/token';
  Map<String, String> headers = {"Content-type": "application/json"};
  String json1 = '{"client_id": "'+client_id+'", "session": "'+session+'", "grant_type": "'+grant_type+'", "auth_type": "'+auth_type+'", "otp": "'+otp+'", "mobile_number": "'+mobileNumber+'"}';

  final response = await http.post(url, headers: headers, body: json1);

  if(response.statusCode==200) {
    Token token;

    var data = json.decode(response.body);

    token = new Token.fromJson(data);

    pref1.setString("access_token", token.access_token);

    return true;
  }else{
    return false;
  }

}

Future<String> LogIn(String phone) async{

  String url = baseUrl+'/otp';
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = '{"phone": "'+phone+'"}';

  final response = await http.post(url, headers: headers, body: json);
  if(response.statusCode==200) {
    return response.body;
  }else if(response.statusCode==401){
    return "Oops! Looks like you are not eligible to use this app";
  }else{
    return "We ran into an error while completing your request. Please try again.";
  }
}

Future<User> getUserDetails(String phone) async {
  SharedPreferences pref2 = await SharedPreferences.getInstance();

  String accessToken = pref2.get("access_token");


  String url = baseUrl + '/users';
  Map<String, String> headers = {
    "Content-type": "application/json",
    "Authorization": "Bearer " + accessToken
  };
  String json1 = '{"phone": "' + phone + '"}';

  final response = await http.post(url, headers: headers, body: json1);

  if (response.statusCode == 200) {
    User user;

    var data = json.decode(response.body);

    user = new User.fromJson(data);
    return user;
  }else{
    return null;
  }
}

Future<User> verifyOTP(String sessionId, String otp,String phone) async{



    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("phone", phone);
    prefs.setString("sessionId", sessionId);
    prefs.setString("otp", otp);

    bool ok = await getTokens();

    if(ok) {
      User user = await getUserDetails(phone);

      if(user==null){
        return null;
      }else{
        return user;
      }


    }else{
      return null;
    }



}

Future<List<Message>> getNewMessages(String phone)  async{

  bool restart = false;

  SharedPreferences pref2 = await SharedPreferences.getInstance();

  String accessToken = pref2.get("access_token");


  String url = baseUrl+'/messages/new';
  Map<String, String> headers = {"Content-type": "application/json", "Authorization":"Bearer "+accessToken};
  String json1 = '{"phone": "'+phone+'"}';

  final response = await http.post(url, headers: headers, body: json1);

  if(response.statusCode==200){

    List<Message> messageList;

    var data = json.decode(response.body) as List;

    messageList = data.map<Message>((json)=>Message.fromJson(json)).toList();

    return messageList;

  }else{

    if(restart==false){
      restart = await getTokens();
      if(restart = true){
        return getNewMessages(phone);
      }else{
        return null;
      }
    }else{
      return null;
    }

  }
  
}

Future<List<Message>> getRespondedMessages(String phone)  async{

  bool restart = false;

  SharedPreferences pref2 = await SharedPreferences.getInstance();

  String accessToken = pref2.get("access_token");


  String url = baseUrl+'/messages/responded';
  Map<String, String> headers = {"Content-type": "application/json", "Authorization":"Bearer "+accessToken};
  String json1 = '{"phone": "'+phone+'"}';

  final response = await http.post(url, headers: headers, body: json1);

  if(response.statusCode==200){

    List<Message> messageList;

    var data = json.decode(response.body) as List;

    messageList = data.map<Message>((json)=>Message.fromJson(json)).toList();

    return messageList;

  }else{

    if(restart==false){
      restart = await getTokens();
      if(restart = true){
        return getRespondedMessages(phone);
      }else{
        return null;
      }
    }else{
      return null;
    }

  }
}

Future<List<Message>> getAllMessages()  async{

  bool restart = false;

  SharedPreferences pref2 = await SharedPreferences.getInstance();

  String accessToken = pref2.get("access_token");


  String url = baseUrl+'/admin/messages';
  Map<String, String> headers = {"Content-type": "application/json", "Authorization":"Bearer "+accessToken};

  final response = await http.get(url, headers: headers);

  if(response.statusCode==200){

    List<Message> messageList;

    var data = json.decode(response.body) as List;

    messageList = data.map<Message>((json)=>Message.fromJson(json)).toList();

    return messageList;

  }else{

    if(restart==false){
      restart = await getTokens();
      if(restart = true){
        return getAllMessages();
      }else{
        return null;
      }
    }else{
      return null;
    }

  }

}

Future<int> updateStatus(int messageId, int newStatus, String phone, double lat, double lng) async{


  bool restart = false;

  SharedPreferences pref2 = await SharedPreferences.getInstance();

  String accessToken = pref2.get("access_token");


  String url = baseUrl+'/messages';
  Map<String, String> headers = {"Content-type": "application/json", "Authorization":"Bearer "+accessToken};
  String json1 = '{"lat": '+lat.toString()+',"lng": '+lng.toString()+',"messageId": '+messageId.toString()+',"newStatus": '+newStatus.toString()+',"phone": "'+phone+'"}';

  final response = await http.put(url, headers: headers, body: json1);

  if(response.statusCode==200) {
    return response.statusCode;
  }else{

    if(restart==false){
      restart = await getTokens();
      if(restart = true){
        return updateStatus(messageId, newStatus, phone,lat,lng);
      }else{
        return null;
      }
    }else{
      return null;
    }
  }

}

Future<int> sendNewMessage(String subject, String message, String phone, String positiveTitle, String negativeTitle) async{

  bool restart = false;

  SharedPreferences pref2 = await SharedPreferences.getInstance();

  String accessToken = pref2.get("access_token");

  String url = baseUrl+'/admin/message/';
  Map<String, String> headers = {"Content-type": "application/json", "Authorization":"Bearer "+accessToken};
  String json = '{"subject": "'+subject+'", "message": "'+message+'", "author": "'+phone+'", "positiveButtonText": "'+positiveTitle+'", "negativeButtonText": "'+negativeTitle+'"}';

  final response = await http.post(url, headers: headers, body: json);

  print(response.body);

  if(response.statusCode==200) {
    return response.statusCode;
  }else{

    if(restart==false){
      restart = await getTokens();
      if(restart = true){
        return sendNewMessage(subject, message, phone,positiveTitle, negativeTitle);
      }else{
        return null;
      }
    }else{
      return null;
    }
  }

}

Future<StatusDetails> getStatusDetails(int messageId) async{

  bool restart = false;

  SharedPreferences pref2 = await SharedPreferences.getInstance();

  String accessToken = pref2.get("access_token");


  String url = baseUrl+'/admin/messages/status';
  Map<String, String> headers = {"Content-type": "application/json", "Authorization":"Bearer "+accessToken};
  String json1 = '{"messageId": "'+messageId.toString()+'"}';

  final response = await http.post(url, headers: headers, body: json1);
  if(response.statusCode==200){

    StatusDetails statusDetails;

    var data = json.decode(response.body);

    statusDetails = new StatusDetails.fromJson(data);

    return statusDetails;

  }else{

    if(restart==false){
      restart = await getTokens();
      if(restart = true){
        return getStatusDetails(messageId);
      }else{
        return null;
      }
    }else{
      return null;
    }

  }
  
}





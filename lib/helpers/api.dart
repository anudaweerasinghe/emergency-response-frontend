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
  String secretKey = "Basic bW9iaWxlOnBpbg==";
  String username = pref1.get("authUsername");
  String password = pref1.get("authPassword");


  String url = baseUrl+'/oauth/token?grant_type='+grant_type+'&username='+username+'&password='+password;
  Map<String, String> headers = {"Authorization": secretKey, "Content-type": "application/json"};
  String json1 = '';

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

  String url = baseUrl+'/login/login';
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

Future<User> verifyOTP(String sessionId, String otp) async{


  String url = baseUrl+'/login/otp';
  Map<String, String> headers = {"Content-type": "application/json"};
  String json1 = '{"sessionId": "'+sessionId+'", "otp": "'+otp+'"}';

  final response = await http.post(url, headers: headers, body: json1);

  if(response.statusCode==200){

    OTPResponse otpResponse;

    var data = json.decode(response.body);

    otpResponse = new OTPResponse.fromJson(data);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("authUsername", otpResponse.authUserName);
    prefs.setString("authPassword", otpResponse.authPassword);

    bool ok = await getTokens();

    if(ok) {
      return otpResponse.user;
    }else{
      return null;
    }

  }else{
    return null;
  }

}

Future<List<Message>> getNewMessages(String phone)  async{

  bool restart = false;

  SharedPreferences pref2 = await SharedPreferences.getInstance();

  String accessToken = pref2.get("access_token");


  String url = baseUrl+'/main/new-messages';
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


  String url = baseUrl+'/main/responded-messages';
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


  String url = baseUrl+'/admin/all-messages';
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

Future<int> updateStatus(int messageId, int newStatus, String phone) async{

  bool restart = false;

  SharedPreferences pref2 = await SharedPreferences.getInstance();

  String accessToken = pref2.get("access_token");


  String url = baseUrl+'/main/update-status';
  Map<String, String> headers = {"Content-type": "application/json", "Authorization":"Bearer "+accessToken};
  String json1 = '{"messageId": "'+messageId.toString()+'", "newStatus": "'+newStatus.toString()+'", "phone": "'+phone+'"}';

  final response = await http.post(url, headers: headers, body: json1);

  if(response.statusCode==200) {
    return response.statusCode;
  }else{

    if(restart==false){
      restart = await getTokens();
      if(restart = true){
        return updateStatus(messageId, newStatus, phone);
      }else{
        return null;
      }
    }else{
      return null;
    }
  }

}

Future<int> sendNewMessage(String subject, String message, String phone) async{

  bool restart = false;

  SharedPreferences pref2 = await SharedPreferences.getInstance();

  String accessToken = pref2.get("access_token");

  String url = baseUrl+'/admin/new-message/';
  Map<String, String> headers = {"Content-type": "application/json", "Authorization":"Bearer "+accessToken};
  String json = '{"subject": "'+subject+'", "message": "'+message+'", "author": "'+phone+'"}';

  final response = await http.post(url, headers: headers, body: json);

  print(response.body);

  if(response.statusCode==200) {
    return response.statusCode;
  }else{

    if(restart==false){
      restart = await getTokens();
      if(restart = true){
        return sendNewMessage(subject, message, phone);
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


  String url = baseUrl+'/admin/status-details';
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





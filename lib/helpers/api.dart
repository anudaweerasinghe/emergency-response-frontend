import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:emergency_response_app/models/user_model.dart';
import 'package:emergency_response_app/models/message_model.dart';
import 'package:emergency_response_app/models/status_details_model.dart';



const baseUrl = "http://localhost:8080";

Future<String> LogIn(String phone) async{
  final response = await http.get(baseUrl+'/main/login?phone='+phone);

  if(response.statusCode==200) {
    return response.body;
  }else if(response.statusCode==401){
    return "Oops! Looks like you are not eligible to use this app";
  }else{
    return "We ran into an error while completing your request. Please try again.";
  }
}

Future<User> verifyOTP(String sessionId, String otp) async{


  final response = await http.get(baseUrl+'/main/otp?sessionId='+sessionId+'&otp='+otp);

  if(response.statusCode==200){

    var user = User(json.decode(response.body));

    return user;
  }else{
    return null;
  }

}

Future<List<Message>> getNewMessages(String phone)  async{
  
  final response = await http.get(baseUrl+'/main/new-messages?phone='+phone);

  if(response.statusCode==200){

    List<Message> messageList;

    var data = json.decode(response.body) as List;

    messageList = data.map<Message>((json)=>Message.fromJson(json)).toList();

    return messageList;

  }else{
    return null;
  }
  
}

Future<List<Message>> getRespondedMessages(String phone)  async{

  final response = await http.get(baseUrl+'/main/responded-messages?phone='+phone);

  if(response.statusCode==200){

    List<Message> messageList;

    var data = json.decode(response.body) as List;

    messageList = data.map<Message>((json)=>Message.fromJson(json)).toList();

    return messageList;

  }else{
    return null;
  }

}

Future<List<Message>> getAllMessages()  async{

  final response = await http.get(baseUrl+'/admin/all-messages');

  if(response.statusCode==200){

    List<Message> messageList;

    var data = json.decode(response.body) as List;

    messageList = data.map<Message>((json)=>Message.fromJson(json)).toList();

    return messageList;

  }else{
    return null;
  }

}

Future<int> updateStatus(int messageId, int newStatus, String phone) async{

  final response = await http.get(baseUrl+'/main/update-status?phone='+phone+'&newStatus='+newStatus.toString()+'&messageId='+messageId.toString());

  return response.statusCode;

}

Future<int> sendNewMessage(String subject, String message, String phone) async{

  String url = baseUrl+'/admin/new-message/';
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = '{"subject": "'+subject+'", "message": "'+message+'", "author": "'+phone+'"}';

  final response = await http.post(url, headers: headers, body: json);

  print(response.body);

  return response.statusCode;


}

Future<StatusDetails> getStatusDetails(int messageId) async{
  
  final response = await http.get(baseUrl+'/admin/status-details?messageId='+messageId.toString());

  if(response.statusCode==200){

    StatusDetails statusDetails;

    var data = json.decode(response.body);

    statusDetails = new StatusDetails.fromJson(data);

    return statusDetails;

  }else{

    return null;

  }
  
}





import 'package:flutter/material.dart';

class Message {

  int id;
  String subject;
  String message;
  int activeStatus;
  String author;
  int safe;
  int noResponse;
  int affected;
  String timestamp;
  String positiveButtonText;
  String negativeButtonText;

  Message({
    this.id,
    this.subject,
    this.message,
    this.activeStatus,
    this.author,
    this.safe,
    this.noResponse,
    this.affected,
    this.timestamp,
    this.positiveButtonText,
    this.negativeButtonText
  });

  factory Message.fromJson(Map<String, dynamic> json){
    return new Message(
        id: json['id'],
        subject: json['subject'],
        message: json['message'],
        activeStatus: json['activeStatus'],
        author: json['author'],
        safe: json['safe'],
        noResponse: json['noResponse'],
        affected: json['affected'],
        timestamp:json['timestamp'],
        positiveButtonText: json['positiveButtonText'],
        negativeButtonText:json['negativeButtonText']
    );
  }


}

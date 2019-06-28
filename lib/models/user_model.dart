import 'package:flutter/material.dart';

class User{

  int id;
  String phone;
  int accessCode;
  String imguri;
  String division;
  String name;

  User(Map<String, dynamic> data) {
  id = data['id'];
  phone = data['phone'];
  accessCode = data['accessCode'];
  imguri = data['imguri'];
  division = data['division'];
  name = data['name'];
}


}
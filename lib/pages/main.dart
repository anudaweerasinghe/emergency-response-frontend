import 'package:flutter/material.dart';
import 'package:emergency_response_app/pages/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new LoginScreen(),
        theme: ThemeData(fontFamily: 'Roboto'),

    );
  }
}




import 'dart:async';
import 'package:flutter/material.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {

    Navigator.pop(context);
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (ctxt) => new LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new SizedBox(
          child: Container(
            child: new Image.asset('images/ADL.png'),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  new Color.fromARGB(255, 255, 65, 108),
                  new Color.fromARGB(255, 255, 75, 43)
                ],
              ),
            ),
          ),
          width: double.infinity,
          height: double.infinity,
        )

      ),
    );
  }
}
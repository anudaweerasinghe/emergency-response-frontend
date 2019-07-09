import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:emergency_response_app/models/message_model.dart';
import 'package:emergency_response_app/helpers/api.dart';
import 'package:emergency_response_app/pages/admin_home.dart';

import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SharedPreferences prefs;
  String name = "";
  String phone = "";
  int accessCode;
  bool isAdmin;

  bool responded;
  bool newMessages;

  List<Message> newMessagesList;
  List<Message> respondedList;

  Map<String, double> userLocation;

  var location = new Location();

  @override
  initState() {
    super.initState();
    isAdmin = false;
    newMessagesList = new List();
    respondedList = new List();
    newMessages = true;
    responded = false;
    getInfo();

  }

  void _showDialog(String response, String title) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(response),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "OK",
                style: new TextStyle(color: Colors.white),
              ),
              color: new Color.fromARGB(255, 255, 75, 43),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  getInfo() async {
    prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name');
    phone = prefs.getString('phone');
    accessCode = prefs.getInt('access_code');
    setState(() {
      if (accessCode == 1) {
        isAdmin = true;
      } else {
        isAdmin = false;
      }
      getMessages();

    });
  }

  getMessages() async {
    List<Message> newl = await getNewMessages(phone);
    List<Message> respondl = await getRespondedMessages(phone);

    newMessagesList = newl.reversed.toList();
    respondedList = respondl.reversed.toList();

    setState(() {

    });
  }

  _changeTabToNew() {
    setState(() {
      getMessages();
      newMessages = true;
      responded = false;
    });
  }

  _changeTabToResponded() {
    setState(() {
      getMessages();
      newMessages = false;
      responded = true;
    });
  }

  Future<Map<String, double>> _getLocation() async {
    var currentLocation = <String, double>{};
    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  @override
  Widget build(BuildContext context) {

    if (newMessagesList == null) {
      return new Scaffold(
          appBar: PreferredSize(
              child: new AppBar(
                title: new Text(
                  'Admin Dashboard',
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        new Color.fromARGB(255, 255, 65, 108),
                        new Color.fromARGB(255, 255, 75, 43)
                      ],
                    ),
                  ),
                ),
              ),
              preferredSize: Size.fromHeight(75)));
    } else {
      return new Scaffold(
          appBar: PreferredSize(
              child: isAdmin
                  ? new AppBar(
                      title: new Text(
                        'Hi ' + name + '\n' + phone,
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      flexibleSpace: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              new Color.fromARGB(255, 255, 65, 108),
                              new Color.fromARGB(255, 255, 75, 43)
                            ],
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        IconButton(
                          icon: new ImageIcon(
                            new AssetImage('images/config.png'),
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (ctxt) => new AdminHomeScreen()),
                            );
                          },
                          color: Colors.white,
                          iconSize: 60,
                        )
                      ],
                    )
                  : new AppBar(
                      title: new Text(
                        'Hi ' + name + '\n' + phone,
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      flexibleSpace: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              new Color.fromARGB(255, 255, 65, 108),
                              new Color.fromARGB(255, 255, 75, 43)
                            ],
                          ),
                        ),
                      )),
              preferredSize: Size.fromHeight(75)),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
              flex:1,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: RaisedButton(
                    elevation: newMessages ? null : 0,
                    onPressed: _changeTabToNew,
                    textColor:
                    newMessages ? Colors.white : Color(0xFFFF4B2B),
                    padding: const EdgeInsets.all(0.0),
                    color: Colors.transparent,
                    disabledElevation: 0,
                    disabledColor: Colors.grey,
                    child: Container(
                      width: double.infinity,
                      decoration: newMessages
                          ? const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFFFF416C),
                              Color(0xFFFF4B2B),
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(0),
                              bottomLeft: Radius.circular(0),
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(0)))
                          : const BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(0),
                              bottomLeft: Radius.circular(0),
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(0))),
                      padding: const EdgeInsets.all(10.0),
                      child: const Text('New Messages',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: RaisedButton(
                    elevation: responded ? null : 0,
                    onPressed: _changeTabToResponded,
                    textColor: responded ? Colors.white : Color(0xFFFF4B2B),
                    padding: const EdgeInsets.all(0.0),
                    color: Colors.transparent,
                    disabledElevation: 0,
                    disabledColor: Colors.grey,
                    child: Container(
                      width: double.infinity,
                      decoration: responded
                          ? const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFFFF416C),
                              Color(0xFFFF4B2B),
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(0),
                              bottomLeft: Radius.circular(0),
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(0)))
                          : const BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(0),
                              bottomLeft: Radius.circular(0),
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(0))),
                      padding: const EdgeInsets.all(10.0),
                      child: const Text('Responded',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ],
            ),
          ),
                Expanded(
                  flex: 19,
                  child: Padding(  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: newMessages
                            ? newMessagesList.length
                            : respondedList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                              ),
                              Card(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 20),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                  newMessages
                                                      ? newMessagesList[index]
                                                      .subject
                                                      : respondedList[index]
                                                      .subject,
                                                  textAlign: TextAlign.left,
                                                  style: new TextStyle(
                                                      fontSize: 23.0,
                                                      fontWeight: FontWeight.w900,
                                                      fontFamily: 'Roboto')),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                  newMessages
                                                      ? newMessagesList[index]
                                                      .timestamp
                                                      : respondedList[index]
                                                      .timestamp,
                                                  textAlign: TextAlign.right,
                                                  style: new TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight: FontWeight.w300,
                                                      fontFamily: 'Roboto')),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 8),
                                        ),
                                        Text(
                                            newMessages
                                                ? newMessagesList[index].message
                                                : respondedList[index].message,
                                            textAlign: TextAlign.left,
                                            style: new TextStyle(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Roboto')),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 8),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 6,
                                              child: RaisedButton(
                                                onPressed: () async {
                                                  userLocation =
                                                  await _getLocation();

                                                  if (userLocation == null) {
                                                    _showDialog(
                                                        "We encountered an error while getting your location. Make sure location services are turned on",
                                                        "Sorry!");
                                                  } else {
                                                    int response =
                                                    await updateStatus(
                                                        newMessages
                                                            ? newMessagesList[
                                                        index]
                                                            .id
                                                            : respondedList[
                                                        index]
                                                            .id,
                                                        1,
                                                        phone,
                                                        userLocation[
                                                        "latitude"],
                                                        userLocation[
                                                        "longitude"]);
                                                    if (response != 200) {
                                                      _showDialog(
                                                          "We encountered an error while updating your status",
                                                          "Sorry!");
                                                    } else {
                                                      String m = newMessages
                                                          ? newMessagesList[index].positiveButtonText
                                                          : respondedList[index].positiveButtonText;
                                                      _showDialog(
                                                          "Your status was successfully updated as "+
                                                              m
                                                              +".",
                                                          "Success!");
                                                    }
                                                  }

                                                  setState(() {
                                                    getMessages();

                                                  });
                                                },
                                                textColor: Colors.white,
                                                padding:
                                                const EdgeInsets.all(0.0),
                                                color: Colors.white,
                                                elevation: 0,
                                                child: Container(
                                                    width: double.infinity,
                                                    decoration: new BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius: new BorderRadius
                                                            .only(
                                                            topLeft: const Radius
                                                                .circular(20.0),
                                                            topRight: const Radius
                                                                .circular(20.0),
                                                            bottomLeft:
                                                            const Radius
                                                                .circular(
                                                                20.0),
                                                            bottomRight:
                                                            const Radius
                                                                .circular(
                                                                20.0))),
                                                    child: new ListTile(
                                                      leading: Icon(
                                                        Icons.sentiment_satisfied,
                                                        color: Colors.white,
                                                        size: 40,
                                                      ),
                                                      title: Text(
                                                          newMessages
                                                              ? newMessagesList[
                                                          index]
                                                              .positiveButtonText
                                                              : respondedList[
                                                          index]
                                                              .positiveButtonText,
                                                          textAlign:
                                                          TextAlign.center,
                                                          style:
                                                          TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w800,
                                                              color: Colors
                                                                  .white)),
                                                    )),
                                              ),
                                            ),
                                            Expanded(flex: 1, child: Container()),
                                            Expanded(
                                              flex: 6,
                                              child: RaisedButton(
                                                onPressed: () async {
                                                  userLocation =
                                                  await _getLocation();

                                                  if (userLocation == null) {
                                                    _showDialog(
                                                        "We encountered an error while getting your location. Make sure location services are turned on",
                                                        "Sorry!");
                                                  } else {
                                                    int response =
                                                    await updateStatus(
                                                        newMessages
                                                            ? newMessagesList[
                                                        index]
                                                            .id
                                                            : respondedList[
                                                        index]
                                                            .id,
                                                        2,
                                                        phone,
                                                        userLocation[
                                                        "latitude"],
                                                        userLocation[
                                                        "longitude"]);
                                                    if (response != 200) {
                                                      _showDialog(
                                                          "We encountered an error while updating your status",
                                                          "Sorry!");
                                                    } else {
                                                      String m = newMessages
                                                          ? newMessagesList[index].negativeButtonText
                                                          : respondedList[index].negativeButtonText;
                                                      _showDialog(
                                                          "Your status was successfully updated as "+
                                                              m
                                                              +".",
                                                          "Success!");
                                                    }
                                                  }
                                                  setState(() {
                                                    getMessages();

                                                  });
                                                },
                                                textColor: Colors.white,
                                                padding:
                                                const EdgeInsets.all(0.0),
                                                color: Colors.white,
                                                elevation: 0,
                                                child: Container(
                                                    width: double.infinity,
                                                    decoration: new BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius: new BorderRadius
                                                            .only(
                                                            topLeft: const Radius
                                                                .circular(20.0),
                                                            topRight: const Radius
                                                                .circular(20.0),
                                                            bottomLeft:
                                                            const Radius
                                                                .circular(
                                                                20.0),
                                                            bottomRight:
                                                            const Radius
                                                                .circular(
                                                                20.0))),
                                                    child: new ListTile(
                                                      leading: Icon(
                                                        Icons
                                                            .sentiment_dissatisfied,
                                                        color: Colors.white,
                                                        size: 40,
                                                      ),
                                                      title: Text(
                                                          newMessages
                                                              ? newMessagesList[
                                                          index]
                                                              .negativeButtonText
                                                              : respondedList[
                                                          index]
                                                              .negativeButtonText,
                                                          textAlign:
                                                          TextAlign.center,
                                                          style:
                                                          TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w800,
                                                              color: Colors
                                                                  .white)),
                                                    )),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ))
                            ],
                          );
                        }),
                  ),
                )

              ],
            ),
          );
    }
  }
}

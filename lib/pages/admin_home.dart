import 'package:flutter/material.dart';
import 'package:emergency_response_app/models/message_model.dart';
import 'package:emergency_response_app/helpers/api.dart';
import 'new_message.dart';
import 'package:emergency_response_app/models/status_details_model.dart';
import 'message_details.dart';

class AdminHomeScreen extends StatefulWidget{

  @override
  _AdminHomeScreenState createState() => new _AdminHomeScreenState();

}

class _AdminHomeScreenState extends State<AdminHomeScreen>{

  List<Message> messagesList;

  @override
  initState() {
    super.initState();
  }

  getMessages() async{

    List<Message> l = await getAllMessages();
    messagesList = l.reversed.toList();

    setState(() {});

  }

  @override
  Widget build(BuildContext context) {

    getMessages();

    List<Color> colorsList= new List();
    colorsList.add(Colors.red);
    colorsList.add(Colors.green);


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
          preferredSize: Size.fromHeight(75)
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              ),
              Expanded(
                flex: 500,
                child:ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index){
                      return Column(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),),
                            Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 6,
                                            child: Text(messagesList[index].subject,
                                                textAlign: TextAlign.left,
                                                style: new TextStyle(
                                                    fontSize: 23.0,
                                                    fontWeight: FontWeight.w900,
                                                    fontFamily: 'Roboto'
                                                )
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: CircleAvatar(
                                              backgroundColor: colorsList[messagesList[index].activeStatus],
                                              radius: 8,
                                            )
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Text(messagesList[index].timestamp,
                                                textAlign: TextAlign.right,
                                                style: new TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w300,
                                                    fontFamily: 'Roboto'
                                                )
                                            ),
                                          ),

                                        ],
                                      ),
                                      Padding(padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),),
                                      Text(
                                          messagesList[index].message,
                                          style: new TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Roboto'
                                          )
                                      ),
                                      Padding(padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 6,
                                            child: RaisedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(builder: (ctxt) => new MessageDetailsScreen(messageId: messagesList[index].id, status: 1,)),
                                                );
                                              },
                                              textColor: Colors.white,
                                              padding: const EdgeInsets.all(0.0),
                                              color: Colors.white,
                                              elevation: 0,
                                              child: Container(
                                                  width: double.infinity,
                                                  decoration: new BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius: new BorderRadius.only(
                                                          topLeft: const Radius.circular(20.0),
                                                          topRight: const Radius.circular(20.0),bottomLeft: const Radius.circular(20.0), bottomRight: const Radius.circular(20.0))),
                                                  child: new ListTile(
                                                    leading: Icon(Icons.sentiment_satisfied, color: Colors.white, size: 40,),
                                                    title: Text(
                                                        messagesList[index].safe.toString(),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)
                                                    ),
                                                  )
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child:Container()
                                          ),
                                          Expanded(
                                            flex: 6,
                                            child: RaisedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(builder: (ctxt) => new MessageDetailsScreen(messageId: messagesList[index].id, status: 0,)),
                                                );
                                              },
                                              textColor: Colors.white,
                                              padding: const EdgeInsets.all(0.0),
                                              color: Colors.white,
                                              elevation: 0,
                                              child: Container(
                                                  width: double.infinity,
                                                  decoration: new BoxDecoration(
                                                      color: Colors.grey,
                                                      borderRadius: new BorderRadius.only(
                                                          topLeft: const Radius.circular(20.0),
                                                          topRight: const Radius.circular(20.0),bottomLeft: const Radius.circular(20.0), bottomRight: const Radius.circular(20.0))),
                                                  child: new ListTile(
                                                    leading: Icon(Icons.sentiment_neutral, color: Colors.white, size: 40,),
                                                    title: Text(
                                                        messagesList[index].noResponse.toString(),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)
                                                    ),
                                                  )
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child:Container()
                                          ),
                                          Expanded(
                                            flex: 6,
                                            child: RaisedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(builder: (ctxt) => new MessageDetailsScreen(messageId: messagesList[index].id, status: 2,)),
                                                );
                                              },
                                              textColor: Colors.white,
                                              padding: const EdgeInsets.all(0.0),
                                              color: Colors.white,
                                              elevation: 0,
                                              child: Container(
                                                  width: double.infinity,
                                                  decoration: new BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius: new BorderRadius.only(
                                                          topLeft: const Radius.circular(20.0),
                                                          topRight: const Radius.circular(20.0),bottomLeft: const Radius.circular(20.0), bottomRight: const Radius.circular(20.0))),
                                                  child: new ListTile(
                                                    leading: Icon(Icons.sentiment_dissatisfied, color: Colors.white, size: 40,),
                                                    title: Text(
                                                        messagesList[index].affected.toString(),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)
                                                    ),
                                                  )
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                            )
                          ]
                      );
                    }
                )

              )

            ]
          )
        ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            Navigator.push(
              context,
              new MaterialPageRoute(builder: (ctxt) => new NewMessageScreen()),
            );
          },
          icon: Icon(Icons.edit, color: Colors.white,),
          backgroundColor:new Color.fromARGB(255, 255, 75, 43),
          label: Text('New Message'),
      ),

    );

  }


}
import 'package:flutter/material.dart';
import 'package:emergency_response_app/helpers/api.dart';
import 'package:emergency_response_app/models/status_details_model.dart';

class MessageDetailsScreen extends StatefulWidget {
  final int messageId;
  final int status;

  MessageDetailsScreen(
      {Key key, @required this.messageId, @required this.status})
      : super(key: key);

  @override
  _MessageDetailsScreenState createState() =>
      new _MessageDetailsScreenState(messageId: messageId, status: status);
}

class _MessageDetailsScreenState extends State<MessageDetailsScreen> {
  int messageId;
  int status;



  StatusDetails statusDetails;

  _MessageDetailsScreenState(
      {Key key, @required this.messageId, @required this.status});

  @override
  initState() {
    super.initState();

    getData();


  }

  getData() async {
    statusDetails = await getStatusDetails(messageId);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    if (status==1) {
      return new Scaffold(
        appBar: PreferredSize(
            child: new AppBar(
              title: new Text(
                statusDetails.message.subject,
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
            preferredSize: Size.fromHeight(75)),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Container(
                    decoration: new BoxDecoration(
                      color: Colors.green, //new Color.fromRGBO(255, 0, 0, 0.0),
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(20.0),
                          topRight: const Radius.circular(20.0),
                          bottomLeft: const Radius.circular(20.0),
                          bottomRight: const Radius.circular(20.0)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.sentiment_satisfied,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Text(
                                statusDetails.message.safe.toString(),
                                textAlign: TextAlign.center,
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 30,
                                    color: Colors.white),
                              ))
                        ],
                      ),
                    )),
              ),
            ),
            Expanded(
                flex: 15,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: statusDetails.safeUsers.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Card(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),
                                    ),
                                    title: Text(
                                        statusDetails.safeUsers[index].name,
                                        textAlign: TextAlign.right,
                                        style: new TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w900,
                                            fontFamily: 'Roboto')),
                                    subtitle: Text(
                                        statusDetails.safeUsers[index]
                                            .division + '    ' +
                                            statusDetails.safeUsers[index]
                                                .phone,
                                        textAlign: TextAlign.right,
                                        style: new TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Roboto')),
                                  )
                              ),
                            ),

                          ],
                        );
                      }),
                ))
          ],
        ),
      );
    }else if ( status ==2){
      return new Scaffold(
        appBar: PreferredSize(
            child: new AppBar(
              title: new Text(
                statusDetails.message.subject,
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
            preferredSize: Size.fromHeight(75)),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Container(
                    decoration: new BoxDecoration(
                      color: Colors.red, //new Color.fromRGBO(255, 0, 0, 0.0),
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(20.0),
                          topRight: const Radius.circular(20.0),
                          bottomLeft: const Radius.circular(20.0),
                          bottomRight: const Radius.circular(20.0)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.sentiment_dissatisfied,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Text(
                                statusDetails.message.affected.toString(),
                                textAlign: TextAlign.center,
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 30,
                                    color: Colors.white),
                              ))
                        ],
                      ),
                    )),
              ),
            ),
            Expanded(
                flex: 15,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: statusDetails.affectedUsers.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Card(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),
                                    ),
                                    title: Text(
                                        statusDetails.affectedUsers[index].name,
                                        textAlign: TextAlign.right,
                                        style: new TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w900,
                                            fontFamily: 'Roboto')),
                                    subtitle: Text(
                                        statusDetails.affectedUsers[index]
                                            .division + '    ' +
                                            statusDetails.affectedUsers[index]
                                                .phone,
                                        textAlign: TextAlign.right,
                                        style: new TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Roboto')),
                                  )
                              ),
                            ),

                          ],
                        );
                      }),
                ))
          ],
        ),
      );
    }else{
      return new Scaffold(
        appBar: PreferredSize(
            child: new AppBar(
              title: new Text(
                statusDetails.message.subject,
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
            preferredSize: Size.fromHeight(75)),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Container(
                    decoration: new BoxDecoration(
                      color: Colors.grey, //new Color.fromRGBO(255, 0, 0, 0.0),
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(20.0),
                          topRight: const Radius.circular(20.0),
                          bottomLeft: const Radius.circular(20.0),
                          bottomRight: const Radius.circular(20.0)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.sentiment_neutral,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Text(
                                statusDetails.message.noResponse.toString(),
                                textAlign: TextAlign.center,
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 30,
                                    color: Colors.white),
                              ))
                        ],
                      ),
                    )),
              ),
            ),
            Expanded(
                flex: 15,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: statusDetails.noResponseUsers.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Card(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),
                                    ),
                                    title: Text(
                                        statusDetails.noResponseUsers[index].name,
                                        textAlign: TextAlign.right,
                                        style: new TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w900,
                                            fontFamily: 'Roboto')),
                                    subtitle: Text(
                                        statusDetails.noResponseUsers[index]
                                            .division + '    ' +
                                            statusDetails.noResponseUsers[index]
                                                .phone,
                                        textAlign: TextAlign.right,
                                        style: new TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Roboto')),
                                  )
                              ),
                            ),

                          ],
                        );
                      }),
                ))
          ],
        ),
      );

    }
  }
}

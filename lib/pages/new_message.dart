import 'package:flutter/material.dart';
import 'package:emergency_response_app/helpers/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';

class NewMessageScreen extends StatefulWidget {
  @override
  _NewMessageScreenState createState() => new _NewMessageScreenState();
}

class _NewMessageScreenState extends State<NewMessageScreen> {

  TextEditingController subjectController = new TextEditingController();
  TextEditingController msgController = new TextEditingController();
  bool isButtonDisabled;

  SharedPreferences prefs;
  String phone="";

  ProgressDialog pr;


  @override
  initState() {
    super.initState();
    msgController.addListener(onChange);
    subjectController.addListener(onChange);

    isButtonDisabled = true;
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
              child: new Text("OK", style: new TextStyle(color: Colors.white),),
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

  getInfo() async{


    prefs = await SharedPreferences.getInstance();
    phone = prefs.getString('phone');
  }


  void onChange(){
    if(msgController.text.length>0&&subjectController.text.length>0){
      setState(() {
        isButtonDisabled = false;
      });
    }else{
      setState(() {
        isButtonDisabled = true;
      });
    }
  }

  sendMsg() async{

    pr.setMessage("Sending...");
    pr.show();

    int response = await sendNewMessage(subjectController.text, msgController.text, phone);

    pr.hide(context);
    
    Navigator.pop(context);
    if(response==200){
      _showDialog("Your message was sent to all staff successfully!", "Success!");
    }else{
      _showDialog("Unfortunately, we encountered an error while sending your message to all staff", "Sorry!");

    }

  }

  @override
  Widget build(BuildContext context) {

    pr = new ProgressDialog(context, ProgressDialogType.Download);

    return new Scaffold(
      appBar: PreferredSize(
          child: new AppBar(
            title: new Text(
              'New Message',
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
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            children: <Widget>[
              Expanded(
                  flex:1,
                  child: Padding(padding: new EdgeInsets.symmetric(horizontal: 1, vertical: 1))
              ),
              Expanded(
                flex: 4,
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    Text('Subject',
                        style:new TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                    TextField(
                        controller: subjectController,
                        maxLength: 15,
                        decoration: InputDecoration(
                          enabledBorder: new UnderlineInputBorder(
                            borderSide: BorderSide(color: new Color.fromARGB(255, 255, 75, 43),
                                width: 2.0),
                          ),
                        )
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                    ),
                    Text('Message',
                        style:new TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                    TextField(
                        controller: msgController,
                        keyboardType: TextInputType.multiline,
                        maxLength: 280,
                        maxLines: 7,
                        decoration: InputDecoration(
                          enabledBorder: new UnderlineInputBorder(
                            borderSide: BorderSide(color: new Color.fromARGB(255, 255, 75, 43),
                                width: 2.0),
                          ),
                        )
                    ),
                  ],
                ),
              ),
              Expanded(
                  flex:2,
                  child: Padding(padding: new EdgeInsets.symmetric(horizontal: 1, vertical: 1))
              ),
              Expanded(
                flex: 0,
                child: new FractionallySizedBox(
                  widthFactor: 1,
                  child:RaisedButton(
                    onPressed: isButtonDisabled?null:sendMsg,
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    disabledElevation: 0,
                    disabledColor: Colors.grey,
                    child: Container(
                      width: double.infinity,
                      decoration: isButtonDisabled?null:const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xFFFF416C),
                            Color(0xFFFF4B2B),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: const Text(
                          'Send Message',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600)
                      ),
                    ),
                  ),
                ),

              ),
            ],
          ),
      )
      
    );
  }
}

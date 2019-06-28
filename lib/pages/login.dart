import 'package:flutter/material.dart';
import 'package:emergency_response_app/helpers/api.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:emergency_response_app/pages/otp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';



class LoginScreen extends StatefulWidget {


  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{



  TextEditingController phoneController = new TextEditingController();
  bool isButtonDisabled;

  ProgressDialog pr;

  SharedPreferences prefs;




  @override
  initState() {
    super.initState();
    phoneController.addListener(onChange);
    isButtonDisabled = true;
    checkLogInStatus();

  }

  checkLogInStatus() async{

    prefs = await SharedPreferences.getInstance();

    if(prefs.get('phone')!=null){
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        new MaterialPageRoute(builder: (ctxt) => new HomeScreen()),
      );
    }

  }

  void onChange(){
    if(phoneController.text.length==9){
      setState(() {
        isButtonDisabled = false;
      });
    }else{
      setState(() {
        isButtonDisabled = true;

      });
    }
  }

  void _showDialog(String response) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Sorry!"),
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

  final Shader linearGradient = LinearGradient(
    colors: <Color>[
      new Color.fromARGB(255, 255, 65, 108),
      new Color.fromARGB(255, 255, 75, 43)
    ],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  _triggerOTP() async{

    pr.show();

    String phone = phoneController.text;

    String response = await LogIn(phone);

    pr.hide(context);
    if(response=="Oops! Looks like you are not eligible to use this app"||response =="We ran into an error while completing your request. Please try again."){
      _showDialog(response);
    }else{


      Navigator.push(
        context,
        new MaterialPageRoute(builder: (ctxt) => new OTPScreen(phoneNum: phone, sessionId: response,)),
      );

    }

  }

  @override
  Widget build(BuildContext context){

    pr = new ProgressDialog(context, ProgressDialogType.Download);
    pr.setMessage('Verifying...');


    return new Scaffold(
        body: new Container(
          margin: new EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
          child: Column(
              children:<Widget>[
                Expanded(
                  flex: 4,
                  child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children:<Widget>[
                        Text('Welcome',
                            style: new TextStyle(
                                fontSize: 50.0,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Roboto'
                            )
                        ),
                        Text('Log in to Continue', textAlign: TextAlign.left,
                          style:new TextStyle(
                              fontSize: 34.0,
                              fontWeight: FontWeight.normal,
                              foreground: Paint()..shader = linearGradient
                          ),
                        ),
                      ]
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      Text('Mobile',
                          style:new TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: phoneController,
                        decoration: InputDecoration(
                            hintText: '77XXXXXXX',
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
                    flex: 1,
                    child: Padding(padding: new EdgeInsets.symmetric(horizontal: 1, vertical: 1))

                ),
                Expanded(
                  flex: 0,
                  child: new FractionallySizedBox(
                    widthFactor: 1,
                    child:RaisedButton(
                      onPressed: isButtonDisabled ? null:_triggerOTP,
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(0.0),
                      disabledElevation: 0,
                      disabledColor: Colors.grey,
                      child: Container(
                        width: double.infinity,
                        decoration: isButtonDisabled ? null: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFFFF416C),
                              Color(0xFFFF4B2B),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(10.0),
                        child: const Text(
                            'Continue',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600)
                        ),
                      ),
                    ),
                  ),

                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 15),)

                ]
          )

          ),
        );


  }
}
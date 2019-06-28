import 'package:flutter/material.dart';
import 'package:emergency_response_app/helpers/api.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:pin_view/pin_view.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:emergency_response_app/pages/login.dart';
import 'package:emergency_response_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emergency_response_app/pages/home.dart';


class OTPScreen extends StatefulWidget {

  final String phoneNum;
  final String sessionId;

  OTPScreen({Key key, @required this.phoneNum, @required this.sessionId}) : super(key: key);


  @override
  _OTPScreenState createState() => new _OTPScreenState(phone: phoneNum, session: sessionId);
}

class _OTPScreenState extends State<OTPScreen>{

  String phone;
  String session;


  _OTPScreenState({Key key,this.phone, this.session});

  ProgressDialog pr;

  final Shader linearGradient = LinearGradient(
    colors: <Color>[
      new Color.fromARGB(255, 255, 65, 108),
      new Color.fromARGB(255, 255, 75, 43)
    ],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  bool isResendBtnDisabled;
  bool isContinueBtnDisabled;
  int mins;
  int secs;
  String otp;


  @override
  initState() {
    super.initState();
    print(phone);
    print(session);
    isResendBtnDisabled = true;
    isContinueBtnDisabled = true;
    mins = 5;
    secs = 0;
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

  void onChange(){
    setState(() {
      isResendBtnDisabled = false;
      phone = phone;
      session = session;
    });
  }

  _otpVerify() async{

    pr.setMessage("Verifying...");
    pr.show();

    User user = await verifyOTP(session, otp);
    pr.hide(context);
    if(user==null){
      _showDialog("The code you have entered is incorrect", "Incorrect Code!");
    }else{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('access_code', user.accessCode);
      prefs.setString('name', user.name);
      prefs.setString('division', user.division);
      prefs.setString('imguri', user.imguri);
      prefs.setString('phone', user.phone);

      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        new MaterialPageRoute(builder: (ctxt) => new HomeScreen()),
      );    }
  }

  _resendCode() async{
    
    pr.setMessage("Resending Code...");
    pr.show();

    String response = await LogIn(phone);

    pr.hide(context);
    if(response=="Oops! Looks like you are not eligible to use this app"||response =="We ran into an error while completing your request. Please try again."){

      Navigator.push(
        context,
        new MaterialPageRoute(builder: (ctxt) => new LoginScreen()),
      );
      _showDialog(response, "Sorry!");

    }else{
      session = response;
      _showDialog("A new code was sent successfully to "+phone+' via SMS.', 'Success!');

    }
    
  }

  @override
  Widget build(BuildContext context){

    pr = new ProgressDialog(context, ProgressDialogType.Download);

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
                        Text('Verify',
                            style: new TextStyle(
                                fontSize: 50.0,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Roboto'
                            )
                        ),
                        Text('Enter the Code we sent via SMS', textAlign: TextAlign.left,
                          style:new TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.normal,
                              foreground: Paint()..shader = linearGradient
                          ),
                        ),
                      ]
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: PinView (
                      count: 6, // co// unt of the fields, excluding dashes
                      autoFocusFirstField: false,
                      inputDecoration: InputDecoration(
                        enabledBorder: new UnderlineInputBorder(
                          borderSide: BorderSide(color: new Color.fromARGB(255, 255, 75, 43),
                              width: 2.0),
                        ),
                      ),
                      submit: (String pin){
                        setState(() {
                          isContinueBtnDisabled = false;
                        });
                        otp = pin;

                      } // gets trig
                ),
                ),
                Expanded(
                    flex: 1,
                    child: Countdown(
                      duration: Duration(seconds: secs, minutes: mins),
                      onFinish: onChange,
                      builder: (BuildContext ctx, Duration remaining) {
                        if(((remaining.inSeconds)-(60*remaining.inMinutes))>9) {
                          return Text(
                              '0${remaining.inMinutes}:${(remaining.inSeconds) -
                                  (60 * remaining.inMinutes)}',
                              style: TextStyle(fontSize: 35,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey));
                        }else{
                          return Text(
                              '0${remaining.inMinutes}:0${(remaining.inSeconds) -
                                  (60 * remaining.inMinutes)}',
                              style: TextStyle(fontSize: 35,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey));
                        }
                        },
                    ),

                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 15),),

                Expanded(
                  flex: 0,
                  child: new FractionallySizedBox(
                    widthFactor: 1,
                    child:RaisedButton(
                      onPressed: isResendBtnDisabled ? null:_resendCode,
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(0.0),
                      disabledElevation: 0,
                      disabledColor: Colors.grey,
                      child: Container(
                        width: double.infinity,
                        decoration: isResendBtnDisabled?null:const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFF434343),
                              Color(0xFF000000),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(10.0),
                        child: const Text(
                            'Resend Code',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600)
                        ),
                      ),
                    ),
                  ),

                ),

                Padding(padding: EdgeInsets.symmetric(vertical: 15),),
                Expanded(
                  flex: 0,
                  child: new FractionallySizedBox(
                    widthFactor: 1,
                    child:RaisedButton(
                      onPressed: isContinueBtnDisabled? null:_otpVerify,
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(0.0),
                      disabledElevation: 0,
                      disabledColor: Colors.grey,
                      child: Container(
                        width: double.infinity,
                        decoration:isContinueBtnDisabled?null: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFFFF416C),
                              Color(0xFFFF4B2B),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(10.0),
                        child: const Text(
                            'Verify',
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

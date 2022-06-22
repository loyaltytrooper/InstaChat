import 'package:flutter/material.dart';
import 'package:instachat/constants.dart';
import 'package:instachat/screens/chat_screen.dart';
import 'welcome_screen.dart' as welcome;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {

  static const String routeID = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override

  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool showSpinner = false;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(height: 48.0,),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Email'),
              ),
              SizedBox(height: 8.0,),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Password ')
              ),
              SizedBox(height: 24.0,),
              welcome.BulletButtons(text: 'Log In', buttonColor: Colors.lightBlueAccent, functionOP: () async {
                setState(() => showSpinner = true);
                try {
                  final user = await _auth.signInWithEmailAndPassword(
                      email: email, password: password);
                  if(user != null) {
                    Navigator.pushNamed(context, ChatScreen.routeID);
                  }
                  setState(() => showSpinner = false);
                }
                on FirebaseAuthException catch(e) {
                  if(e.code == 'user-not-found')
                    print('Wrong email provided');
                  else
                    print("Wrong password");
                  setState(() => showSpinner = false);
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
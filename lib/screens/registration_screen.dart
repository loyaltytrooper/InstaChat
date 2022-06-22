import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instachat/constants.dart';
import 'package:instachat/screens/chat_screen.dart';
import 'welcome_screen.dart' as welcome;
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'chat_screen.dart' as chat;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {

  static const String routeID = '/register';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = auth.FirebaseAuth.instance;
  late String email;
  late String password;
  bool showSpinner = false;
  
  @override
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
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Password')
              ),
              SizedBox(
                height: 24.0,
              ),
              welcome.BulletButtons(text: 'Register', buttonColor: Colors.blueAccent, functionOP: () async {
                setState(() => showSpinner = true);
                try{
                   final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                    if(newUser != null) {
                       Navigator.pushNamed(context, chat.ChatScreen.routeID);
                    setState(() => showSpinner = false);
                    }
                    else {
                      throw("Incorrect email and/or password");
                   }
                }
                catch(err){
                  print(err);
                }
              },),
            ],
          ),
        ),
      ),
    );
  }
}
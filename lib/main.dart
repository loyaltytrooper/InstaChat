import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instachat/screens/loading_screen.dart';
import 'package:instachat/screens/welcome_screen.dart';
import 'package:instachat/screens/login_screen.dart';
import 'package:instachat/screens/registration_screen.dart';
import 'package:instachat/screens/chat_screen.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Wrong initialization, it has error');
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              theme: ThemeData(
                textTheme: TextTheme(
                  bodyText1: TextStyle(color: Colors.black54),
                ),
              ),
              home: WelcomeScreen(),
              initialRoute: WelcomeScreen.routeID,
              routes: {
                WelcomeScreen.routeID: (context) => WelcomeScreen(),
                RegistrationScreen.routeID: (context) => RegistrationScreen(),
                LoginScreen.routeID: (context) => LoginScreen(),
                ChatScreen.routeID: (context) => ChatScreen(),
              },
            );
          }

          return LoadingScreen();
        }
    );
  }
}
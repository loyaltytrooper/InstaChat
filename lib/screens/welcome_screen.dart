import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:instachat/screens/login_screen.dart';
import 'package:instachat/screens/registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String routeID = '/welcome';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController
      linearController; // Declared here so that its state is local to the class instead of the init function
  late Animation animation;

  @override
  void initState() {
    super.initState();
    linearController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    linearController.forward();

    animation =
        ColorTween(begin: Colors.blueGrey.shade300, end: Colors.amber.shade50)
            .animate(linearController);

    animation.addListener(() {
      setState(() {
        print(animation.value);
      });
    });

    linearController.addListener(() {
      setState(
          () {}); // Empty setState and in this block because our value has to keep updating
      print(linearController.value);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: linearController.value * 80,
                    ),
                  ),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Flash Chat',
                      textStyle: const TextStyle(
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.black54,
                      ),
                      speed: const Duration(milliseconds: 500),
                    ),
                  ],
                  totalRepeatCount: 3,
                  pause: const Duration(seconds: 1),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                ),
              ],
            ),
            const SizedBox(height: 48.0,),
            BulletButtons(text: 'Login', buttonColor: Colors.lightBlueAccent, functionOP: () => Navigator.pushNamed(context, LoginScreen.routeID)),
            BulletButtons(text: 'Register', buttonColor: Colors.blueAccent, functionOP: () => Navigator.pushNamed(context, RegistrationScreen.routeID)),
          ],
        ),
      ),
    );
  }
}

class BulletButtons extends StatelessWidget {

  late String text;
  late Color buttonColor;
  final void Function()? functionOP;

  BulletButtons({required this.text, required this.buttonColor, required this.functionOP});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: buttonColor,
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: functionOP,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

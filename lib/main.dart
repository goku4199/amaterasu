import 'package:flutter/material.dart';
import 'package:amaterasu/screens/welcome_screen.dart';
import 'package:amaterasu/screens/login_screen.dart';
import 'package:amaterasu/screens/registration_screen.dart';
import 'package:amaterasu/screens/chat_screen.dart';

void main() => runApp(amaterasu());

class amaterasu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /*theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.black54),
        ),
      ),*/
      initialRoute: WelcomeScreen.id,

      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen()
        //if you use '/routename' format define a '/' for one route bcz its necessary
      },
    );
  }
}
//https://api.flutter.dev/flutter/animation/Curves-class.html
//mixin is used when we have to give multiple features to a class
//declaration mixin CanSwim{
//  void swim(){
//
//  }
//}
//class classname with mixin1,mixin2
//animated_text_kit dependency for animation
//https://pub.dev/packages/animated_text_kit
//DBMS Firebase
//firebase will help us to save our message data and user details in the cloud by using there pre build methods and classes
//firebase feature used :-cloud firestore,authentication
//application id :- android/app/build.gradle
//google-services.json should be in android/app folder
//add google services gradle plugin
//enable sign in authentication in firebase email/password
//after setting authentication its time to setup cloud firestore in the console
//start in test mode after than change to locked mode
//based on nosql
//change firebase rules so that only authenticated user can access the database

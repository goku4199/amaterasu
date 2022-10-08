import 'package:flutter/material.dart';
import 'package:amaterasu/components/rounded_button.dart';
import 'package:amaterasu/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';//for showing spinner

class LoginScreen extends StatefulWidget {

  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;//if true spinner will show if false spinner will not show
  final _auth = FirebaseAuth.instance;
  String email;
  String password;

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
              Flexible(
                child: Hero(

                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
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
                  //Do something with the user input.
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                  //Do something with the user input.
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(title: 'Log In',colour: Colors.lightBlueAccent,onPressed: () async{//since its asynchronus so after setstate try block will be executed in parallel to widget rebuilding
                setState(() {
                  showSpinner = true;//in order to show the spinner widget must be rebuild
                });

                try{
                  final user = await _auth.signInWithEmailAndPassword(email: email, password: password);

                  if(user != null){
                    Navigator.pushNamed(context, ChatScreen.id);
                  }

                  setState(() {
                    showSpinner = false;//as soon as it becomes false navigator will push to chat screen
                  });
                }
                catch(e){
                  print(e);
                  setState(() {
                    showSpinner = false;//as soon as it becomes false navigator will push to chat screen
                  });
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
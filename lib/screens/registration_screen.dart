import 'package:amaterasu/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:amaterasu/components/rounded_button.dart';
import 'package:amaterasu/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';//for showing spinner

class RegistrationScreen extends StatefulWidget {

  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _auth = FirebaseAuth.instance;//static instance of the class
  bool showSpinner = false;//if true spinner will show if false spinner will not show
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
              Flexible(//if you can't take the size of the widget inside flexible then be smaller so that other parts of screen is visible
                child: Hero(//hero widget for animation transition
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
                  //Do something with the user input.
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
                  //Do something with the user input.
                  password = value;
                },
                decoration:kTextFieldDecoration.copyWith(hintText: 'Enter your password'),//copyWith:- change a particular thing out of all things we can change in kTextFieldDecoration
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                  title: 'Register',
                  colour: Colors.blueAccent,
                  onPressed: () async {//since its asynchronus so after setstate try block will be executed in parallel to widget rebuilding
                    setState(() {
                      showSpinner = true;//in order to show the spinner widget must be rebuild
                    });
                    //print(email);
                    //print(password);
                    try{
                      final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);


                      if(newUser != null){
                        Navigator.pushNamed(context, ChatScreen.id);
                      }

                      setState(() {
                        showSpinner = false;//as soon as it becomes false navigator will push to chat screen
                      });
                    }
                    catch(e){
                      print(e);
                    }
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}